//
//  CustomTextfield.swift
//  Heath Diary
//
//  Created by Майлс on 03.07.2023.
//

import SwiftUI

struct CustomTextfield: View {
    
    //MARK: - PROPERTIES
    let type: String
    let title: String
    
    @Binding var text: String
    
    
    //MARK: - BODY
    var body: some View {
        HStack {
            if type == "nonprivate" {
                TextField(title, text: $text)
            } else {
                SecureField(title, text: $text)
            }
            
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark")
            }
            .opacity(text.isEmpty ? 0 : 1)
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 50)
        .background { RoundedRectangle(cornerRadius: 15).stroke() }
        .foregroundColor(.primary)
    }
}


//MARK: - PREVIEW
struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextfield(type: "nonprivate", title: "Почта", text: .constant("test@gmail.com"))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            
            CustomTextfield(type: "private", title: "Пароль", text: .constant("11223322"))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
