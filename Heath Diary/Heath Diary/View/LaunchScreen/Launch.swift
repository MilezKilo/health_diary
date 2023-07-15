//
//  Launch.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//

import SwiftUI

struct Launch: View {
    
    //MARK: - PROPERTIES
    @State private var animationAmount: CGFloat = 1
    @Binding var showLaunchScreen: Bool
    
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 25) {
            Image("heart")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.red)
                .scaleEffect(animationAmount)
                .animation(
                    .linear(duration: 0.5)
                    .delay(0.4)
                    .repeatForever(autoreverses: true),
                    value: animationAmount)
                .onAppear { animationAmount = 1.1 }
            
            Text("Моё здоровье!")
                .font(.title)
                .foregroundColor(.primary)
        }
        .foregroundColor(.primary)
        .offset(y: -25)
        .navigationTitle("Добро пожаловать!")
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.default) {
                    self.showLaunchScreen = false
                }
            }
        }
    }
}


//MARK: - PREVIEW
struct Launch_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                Launch(showLaunchScreen: .constant(true))
                    .preferredColorScheme(.light)
            }
            
            NavigationStack {
                Launch(showLaunchScreen: .constant(true))
                    .preferredColorScheme(.dark)
            }
        }
    }
}
