//
//  AddItemView.swift
//  Heath Diary
//
//  Created by Майлс on 10.07.2023.
//

import SwiftUI

struct AddItemView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var dateVM: DataVM
    @EnvironmentObject private var drugVM: DrugVM
    
    @State private var title: String = ""
    @State private var dosage: Int = 0
    @State private var efficiency: Int = 0
    @State private var date: Date = .init()
    @State private var wellBeing: String = ""
    
    var body: some View {
        VStack {
            upperView
            lowerView
            Spacer()
            addItemButton
        }
        .foregroundColor(.primary)
    }
}

//MARK: - VIEWS
extension AddItemView {
    private var header: some View {
        HStack {
            backButton
            Text("Добавить запись")
                .font(.largeTitle)
                .bold()
            
            Spacer()
        }
        .foregroundColor(.primary)
    }
    
    private var dosageAndEfficiencyFields: some View {
        HStack {
            VStack(alignment: .leading,spacing: 0) {
                
                Text("Дозировка в мг")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.7))
                
                Picker(selection: $dosage, label: Text("")) {
                    ForEach(Array(stride(from: 5, to: 1000, by: 5)), id: \.self) { item in
                        Text("\(item)")
                    }
                }
                .frame(width: 100, height: 75)
                .pickerStyle(.inline)
            }
            
            VStack(spacing: 0) {
                Text("Самочувствие по 10-ти бальной шкале")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.7))
                
                Picker(selection: $efficiency, label: Text("")) {
                    ForEach(1..<11) { item in
                        Text("\(item)")
                    }
                }
                .frame(width: 250, height: 75)
                .pickerStyle(.inline)
            }
        }
    }
    private var dateAndTimeFields: some View {
        HStack(alignment: .bottom, spacing: 12) {
            HStack(spacing: 12) {
                Text(date.toString("EEEE dd MMMM"))
                    .font(.caption)
                
                Image(systemName: "calendar")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .overlay {
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .blendMode(.destinationOver)
                    }
            }
            .offset(y: -5)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.primary.opacity(0.7))
                    .frame(height: 1)
                    .offset(y: 5)
            }
            
            HStack(spacing: 12) {
                Text(date.toString("hh:mm a"))
                    .font(.caption)
                
                Image(systemName: "clock")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .overlay {
                        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                            .blendMode(.destinationOver)
                    }
            }
            .offset(y: -5)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.primary.opacity(0.7))
                    .frame(height: 1)
                    .offset(y: 5)
            }
        }
    }
    
    private var upperView: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            CustomTextfield(type: "nonprivate", title: "Название лекарства", text: $title)
            dosageAndEfficiencyFields
            VStack(alignment: .leading, spacing: 15) {
                Text("Дата")
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.7))
                dateAndTimeFields
            }
        }
        .padding(15)
        .padding(.bottom, 5)
        .background(Color.blue.opacity(0.8))
    }
    private var lowerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Как ваше самочувствие сегодня?")
                .font(.caption)
                .foregroundColor(.primary.opacity(0.7))
            
            TextEditor(text: $wellBeing)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                .cornerRadius(15.0)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 1)
                }
        }
        .padding([.top, .horizontal], 15)
    }
}

//MARK: - BUTTONS
extension AddItemView {
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.down")
                .foregroundColor(.primary)
                .font(.title2)
        }
    }
    private var addItemButton: some View {
        Button(action: {
            drugVM.addValue(
                userUID: dateVM.currentProfile!.uid,
                title: title,
                dosage: Int16(dosage),
                date: date,
                efficiency: Int16(efficiency),
                wellBeing: wellBeing)
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Добавить")
                .font(.headline)
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 55)
                .background { Color.blue.cornerRadius(15) }
                .foregroundColor(.primary)
                .padding(.horizontal)
        }
    }
}

//MARK: - PREVIEW
struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                AddItemView()
                    .preferredColorScheme(.light)
                    .environmentObject(DataVM())
                    .environmentObject(DrugVM())
            }
            
            NavigationStack {
                AddItemView()
                    .preferredColorScheme(.dark)
                    .environmentObject(DataVM())
                    .environmentObject(DrugVM())
            }
        }
    }
}
