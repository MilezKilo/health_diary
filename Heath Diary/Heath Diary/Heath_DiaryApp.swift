//
//  Heath_DiaryApp.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//

import SwiftUI
import Firebase

@main
struct Heath_DiaryApp: App {
    
    //MARK - PROPERTIES
    @State private var showLaunchScreen: Bool = true
    @State private var showSignInScreen: Bool = true
    
    @StateObject private var dataVM: DataVM = DataVM()
    @StateObject private var drugVM: DrugVM = DrugVM()
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    //MARK: - MAIN STACK
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Если свойство имеет значение true, переходим к Launch View
                if showLaunchScreen {
                    Launch(showLaunchScreen: $showLaunchScreen)
                        .task {
                            try? await dataVM.loadCurrentUser()
                            self.showSignInScreen = dataVM.currentUser == nil
                        }
                        .transition(.opacity)
                }
                
                //Если свойство имеет значение false - переходим к Auth View и Main View
                if !showLaunchScreen {
                    // Если свойство имеет значение false - переходим к Main View
                        if !showSignInScreen {
                            NavigationStack {
                                Main(showSignInScreen: $showSignInScreen)
                                .toolbar(.hidden)
                                .transition(.opacity)
                            }
                        }

                    // Если свойство имеет значение true - переходим к Auth View
                    if showSignInScreen {
                        NavigationStack {
                            Authotization(showSignInScreen: $showSignInScreen)
                            .toolbar(.hidden)
                            .transition(.opacity)
                        }
                    }
                }
            } // КОНЕЦ NAVIGATION STACK
            // Передаем в дочение View все данные двух ViewModel
            .environmentObject(dataVM)
            .environmentObject(drugVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
