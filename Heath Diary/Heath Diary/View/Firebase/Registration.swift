//
//  Registration.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//

import SwiftUI

struct Registration: View {
    
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var dataVM: DataVM
    
    @State private var showAlert: Bool = false
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 15) {
            header
            Image("registration")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            registrationTextfields
            Spacer()
            registrationButton
        }
        .foregroundColor(.primary)
        .alert(isPresented: $showAlert) { alert() }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - VIEWS
extension Registration {
    private var header: some View {
        HStack {
            backButton
            Text("Регистрация")
                .font(.largeTitle)
                .bold()
            
            Spacer()
        }
        .foregroundColor(.primary)
        .padding()
    }
    private var registrationTextfields: some View {
        VStack(spacing: 35) {
            CustomTextfield(type: "nonprivate", title: "Почта", text: $dataVM.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            CustomTextfield(type: "private", title: "Пароль", text: $dataVM.password)
            CustomTextfield(type: "nonprivate", title: "Имя", text: $dataVM.firstName)
            CustomTextfield(type: "nonprivate", title: "Фамилия", text: $dataVM.lastName)
            CustomTextfield(type: "nonprivate", title: "Заболевание", text: $dataVM.disease)
        }
    }
}

//MARK: - BUTTONS
extension Registration {
    private var backButton: some View {
        Button(action: {
            dataVM.email = ""
            dataVM.password = ""
            dataVM.firstName = ""
            dataVM.lastName = ""
            dataVM.disease = ""
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .font(.title2)
        }
    }
    private var registrationButton: some View {
        Button(action: {
            guard dataVM.email.count > 6,
                  dataVM.password.count > 4,
                  dataVM.firstName.count > 2,
                  dataVM.lastName.count > 2,
                  dataVM.disease.count > 2
            else { showAlert.toggle(); return }
            
            Task {
                do {
                    try await AuthenticationManager.shared.createUser(
                        email: dataVM.email,
                        password: dataVM.password,
                        firstName: dataVM.firstName,
                        lastName: dataVM.lastName,
                        disease: dataVM.disease)
                    
                    dataVM.email = ""
                    dataVM.password = ""
                    dataVM.firstName = ""
                    dataVM.lastName = ""
                    dataVM.disease = ""
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Зарегестрироваться")
                .font(.headline)
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 55)
                .background { Color.blue.cornerRadius(15) }
                .foregroundColor(.primary)
        }
    }
}

//MARK: - OTHERS
extension Registration {
    private func alert() -> Alert {
        Alert(
            title: Text("Заполните все поля"),
            message: nil,
            dismissButton: .default(Text("Хорошо")))
    }
}

//MARK: - PREVIEW
struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                Registration()
                    .preferredColorScheme(.light)
                    .environmentObject(DataVM())
            }
            
            NavigationStack {
                Registration()
                    .preferredColorScheme(.dark)
                    .environmentObject(DataVM())
            }
        }
    }
}
