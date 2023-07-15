//
//  DrugVM.swift
//  Heath Diary
//
//  Created by Майлс on 09.07.2023.
//

import Foundation
import CoreData

//title: Strint
//dosage: Int16
//date: Date
//efficiency: Int16
//wellBeing: String

///Класс для взаимодействия с пользователем для добавления новых записей о принятых лекарствах.
class DrugVM: ObservableObject {
    
    ///Свойство, которое служит для отображения на экран записей о принятых лекарствах и самочувствии.
    @Published var drugs: [DrugEntity] = []
    
    ///Контейнер для хранения новых данных о принятых лекарствах.
    let container: NSPersistentContainer
    
    init() {
        //В инициализаторе происходит извлечение записанных в контейнер данных.
        container = NSPersistentContainer(name: "DrugModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("FETCHING DATA ERROR: \(error)")
            }
        }
        fetchDataFromContainer()
    }
    
    ///Приватный метод извлечения данных из контейнера.
    private func fetchDataFromContainer() {
        let request = NSFetchRequest<DrugEntity>(entityName: "DrugEntity")
        do {
            drugs = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR: \(error)")
        }
        
    }
    
    ///Метод сохранения данных в контейнер. Данных метод используется в любом случае, неважно удаление это, или запись данных.
    func saveData() {
        do {
            try container.viewContext.save()
            fetchDataFromContainer()
        } catch let error {
            print("SAVING DATA ERROR: \(error)")
        }
    }
    
    ///Метод добавления новых данных в контейнер, в конце данного метода происходит обращение к методу сохранения данных.
    func addValue(userUID: String, title: String, dosage: Int16, date: Date, efficiency: Int16, wellBeing: String) {
        let newValue = DrugEntity(context: container.viewContext)
        newValue.userUID = userUID
        newValue.title = title
        newValue.dosage = dosage
        newValue.date = date
        newValue.efficiency = efficiency
        newValue.wellBeing = wellBeing
        saveData()
    }
    
    ///Метод удаления данных из конетйнера.
    func deleteValue(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let value = drugs[index]
        container.viewContext.delete(value)
        saveData()
    }
}
