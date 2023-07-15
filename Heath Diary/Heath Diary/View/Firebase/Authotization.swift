//
//  Authotization.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//


import SwiftUI

struct Authotization: View {
    
    //MARK: - PROPERTIES
    @Binding var showSignInScreen: Bool
    
    @State private var showResetOptions: Bool = false

    @EnvironmentObject private var dataVM: DataVM
    
    
    //MARK: - BODY
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 75) {
                header
                VStack {
                    authorizationStack
                    Spacer()
                    registrationStack
                }
                .opacity(showResetOptions ? 0 : 1)
            }
            .padding(.vertical, 50)
            
            resetPasswordSheet
        }
        .foregroundColor(.primary)
        .ignoresSafeArea()
    }
}

//MARK: - VIEWS
extension Authotization {
    private var header: some View {
        VStack(spacing: 25) {
            
            HStack {
                Text("Мое здоровье")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
            }
            .padding()
                            
            Image("heart")
                .resizable()
                .frame(width: 125, height: 125)
        }
    }
    private var authorizationStack: some View {
        VStack {
            CustomTextfield(type: "nonprivate", title: "Почта", text: $dataVM.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            CustomTextfield(type: "private", title: "Пароль", text: $dataVM.password)
            authButton
            openResetSheetButton
        }
    }
    private var registrationStack: some View {
        VStack {
            Text("Регистрация при помощи")
                .font(.callout)
                .bold()
            
            HStack(spacing: 25) {
                NavigationLink(destination: Registration()) {
                    Image("mail")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
        }
    }
    private var resetPasswordSheet: some View {
        VStack {
            HStack {
                closeResetSheetButton
                Spacer()
            }
            .padding([.bottom, .leading])
            CustomTextfield(type: "nonprivate", title: "Почта", text: $dataVM.email)
            resetPasswordButton
            Spacer()
        }
        .padding(.top)
        .background { Color.customColors.reversedPrimary .shadow(color: .primary, radius: 3)}
        .frame(height: showResetOptions ? 200 : 0)
        .opacity(showResetOptions ? 1 : 0)
    }
}

//MARK: - BUTTONS
extension Authotization {
    //AUTHORIZATION BUTTONS
    private var authButton: some View {
        Button(action: {
            Task {
                do {
                    try await AuthenticationManager.shared.signIn(
                        email: dataVM.email,
                        password: dataVM.password)
                    
                    withAnimation(.default) {
                        showSignInScreen = false
                    }
                    
                    dataVM.email = ""
                    dataVM.password = ""
                } catch {
                    print(error.localizedDescription)
                }
            }
        }) {
            Text("Авторизироваться")
                .font(.headline)
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 55)
                .background { Color.blue.cornerRadius(15) }
                .foregroundColor(.primary)
        }
    }
    
    //RESET PASSWORD BUTTONS
    private var openResetSheetButton: some View {
        Button(action: {
            withAnimation(.default) {
                self.showResetOptions = true
            }
            dataVM.email = ""
            dataVM.password = ""
        }) {
            Text("Забыли пароль?")
                .font(.callout)
        }
    }
    private var closeResetSheetButton: some View {
        Button(action: {
            withAnimation(.default) {
                self.showResetOptions.toggle()
            }
            dataVM.email = ""
            dataVM.password = ""
        }) {
            Image(systemName: "arrow.down")
                .font(.title2)
                .foregroundColor(.primary)
        }
    }
    
    private var resetPasswordButton: some View {
        Button(action: {
            Task {
                do {
                    try await AuthenticationManager.shared.resetPassword(email: dataVM.email)
                    
                    dataVM.email = ""
                    
                    self.showResetOptions = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }) {
            Text("Сбросить пароль")
                .font(.headline)
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.95, height: 55)
                .background { Color.blue.cornerRadius(15) }
                .foregroundColor(.primary)
        }
    }
}


//MARK: - PREVIEW
struct Authotization_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                Authotization(showSignInScreen: .constant(true))
                    .preferredColorScheme(.light)
                    .environmentObject(DataVM())
            }
            
            NavigationStack {
                Authotization(showSignInScreen: .constant(true))
                    .preferredColorScheme(.dark)
                    .environmentObject(DataVM())
            }
        }
    }
}
