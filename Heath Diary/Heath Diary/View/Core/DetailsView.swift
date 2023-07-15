//
//  DetailsView.swift
//  Heath Diary
//
//  Created by Майлс on 11.07.2023.
//

import SwiftUI

struct DetailsView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) private var presentationMode
    let drug: DrugEntity
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            upperView
            lowerView
            Spacer()
        }
        .foregroundColor(.primary)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

//MARK: - VIEWS
extension DetailsView {
    private var upperView: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    backButton
                    Spacer()
                }
                Text("Моё самочувствие за \(Date.getDate(date: drug.date ?? Date()))")
                    .font(.title)
            }
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Принятое лекарство: \(drug.title ?? "")")
                Text("Дозировка лекарства:  \(drug.dosage)мг")
                Text("Самочувствие (по шкале до 10): \(drug.efficiency)")
            }
        }
        .padding(15)
        .padding(.bottom, 5)
        .background(Color.red.opacity(0.8))
    }
    private var lowerView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Запись в дневнике")
                .font(.caption)
            Text(drug.wellBeing ?? "Запись отсутствует")
        }
        .padding([.top, .horizontal], 15)
    }
}

//MARK: - BUTTONS
extension DetailsView {
    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.primary)
                .font(.title2)
        }
    }
}

/*
//MARK: - PREVIEW
struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                DetailsView()
                    .preferredColorScheme(.light)
//                    .environmentObject(DataVM())
            }

            NavigationStack {
                DetailsView()
                    .preferredColorScheme(.dark)
//                    .environmentObject(DataVM())
            }
        }
    }
}
*/
