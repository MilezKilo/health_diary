//
//  AuthorizationManager.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Структура описывающая сущность пользователя для регистрации и хранении в Firebase.
struct UserModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

/// Класс с синглетоном, для использования всех методов связанных с Firebase и Firestore.
final class AuthenticationManager {
    
    ///Синглетон описывающий класс AuthenticationManager со всеми свойствами и методами.
    static let shared = AuthenticationManager()
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    //Приватный инициализатор, нужен для того, чтобы не создавать экземпляры класса AuthenticationManager
    private init() { }
    
}

//MARK: - МЕТОДЫ СОЗДАНИЯ ПОЛЬЗОВАТЕЛЯ
extension AuthenticationManager {
    ///Метод создания пользователя для Firebase.
    func createUser(email: String, password: String, firstName: String, lastName: String, disease: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
        
        self.storeCreatedUser(email: email, firstName: firstName, lastName: lastName, disease: disease)
    }
    
    ///Метод создания пользователя для Firestore.
    private func storeCreatedUser(email: String, firstName: String, lastName: String, disease: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = [
            "uid" : uid,
            "email" : email,
            "first_name" : firstName,
            "last_name" : lastName,
            "disease" : disease
            ]
        db.collection("users")
            .document(uid)
            .setData(userData) { error in
                if let error = error {
                    print(error)
                    return
                }
                
                print("Success!")
            }
    }
}

//MARK: - МЕТОДЫ АВТОРИЗАЦИИ, ВЫХОДА И ПОЛУЧЕНИЕ ДАННЫХ О ПОЛЬЗОВАТЕЛЕ
extension AuthenticationManager {
    ///Метод авторизации пользователя через Firebase.
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    ///Метод выхода из текущего профиля.
    func userSignOut() throws {
        try auth.signOut()
    }
    
    ///Метод получения данных о текущем авторизованном пользователе в Firebase.
    func getAuthenticatedUser() throws -> UserModel {
        guard let user = auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return UserModel(user: user)
    }
    
    ///Метод получения данных о текущем авторизованном пользователе из Firestore.
    func loadUserFromStore(UID: String) async throws -> UserProfile {
        let snapshot = try await db.collection("users")
            .document(UID)
            .getDocument()
        
        guard let data = snapshot.data(), let uid = data["uid"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String ?? ""
        let firstName = data["first_name"] as? String ?? ""
        let lastName = data["last_name"] as? String ?? ""
        let disease = data["disease"] as? String ?? ""
        
        return UserProfile(uid: uid, email: email, firstName: firstName, lastName: lastName, disease: disease)
    }
}


//MARK: - МЕТОДЫ СБРОСА ПАРОЛЯ И УДАЛЕНИЯ ПОЛЬЗОВАТЕЛЯ
extension AuthenticationManager {
    ///Метод сброса пароля через почту текущего пользователя.
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    ///Метод удаления текущего ползователя
    func deleteUser() async throws {
        guard let user = auth.currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
}
