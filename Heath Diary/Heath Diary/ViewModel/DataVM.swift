//
//  DataVM.swift
//  Heath Diary
//
//  Created by Майлс on 05.07.2023.
//

import Foundation
import Firebase

/// Класс для взаимодействия с пользователем при регистрации/авторизации.
@MainActor
final class DataVM: ObservableObject {
    
    //СВОЙСТВА СОДЕРЖАЩИЕ ТЕКУЩЕГО ПОЛЬЗОВАТЕЛЯ
    @Published var currentUser: UserModel? = nil
    @Published var currentProfile: UserProfile? = nil
    
    //ДЛЯ FIREBASE
    @Published var email: String = ""
    @Published var password: String = ""
    
    //ДЛЯ FIRESTORE
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var disease: String = ""
    
    ///Метод получения авторизированного пользователя, необходим для добавления новых данных о принятых лекарствах.
    func loadCurrentUser() async throws {
        self.currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
        
        guard self.currentUser != nil else { return }
        
        self.currentProfile = try await AuthenticationManager.shared.loadUserFromStore(UID: currentUser!.uid)
    }
}
