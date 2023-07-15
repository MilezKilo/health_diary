//
//  Date.swift
//  Heath Diary
//
//  Created by Майлс on 10.07.2023.
//

import Foundation

extension Date {
    ///Метод возвращающий локализованную на Русский язык отфармотировнную дату.
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    ///Метод получения даты и времени в уменьшенном стиле.
    static func getDateAndTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    ///Метод получения времени в уменьшенном стиле.
    static func getTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    ///Метод получения даты в уменьшенном стиле.
    static func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
