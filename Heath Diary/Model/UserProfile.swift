//
//  User.swift
//  Heath Diary
//
//  Created by Майлс on 08.07.2023.
//

import Foundation

///Структура описывающая пользователя для создании и хранении в Firestore.
struct UserProfile {
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let disease: String
}
