//
//  Main.swift
//  Heath Diary
//
//  Created by Майлс on 02.07.2023.
//

import SwiftUI

struct Main: View {
    
    //MARK: - PROPERTIES
    @Binding var showSignInScreen: Bool
    @State private var showMenu: Bool = false
    @State private var showAddItemView: Bool = false
    
    @EnvironmentObject private var dataVM: DataVM
    @EnvironmentObject private var drugVM: DrugVM
    
    @State private var offset: CGFloat = 0
    
    //MARK: - BODY
    var body: some View {
        ZStack {
            if showMenu {
                sideMenu
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
            
            mainView
                .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                .offset(x: showMenu ? getRect().width / 1.3 : offset)
//                .onTapGesture { withAnimation(.default) { self.showMenu = false } }
        }
        .foregroundColor(.primary)
        .fullScreenCover(isPresented: $showAddItemView) { AddItemView() }
        .task { try? await dataVM.loadCurrentUser() }
    }
}

//MARK: - SIDE MENU VIEWS
extension Main {
    private var sideMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 24) {
                userImage
                userFullName
                userEmail
                userDisease
                
                Spacer()
                sideMenuButtons
            }
            .padding(.horizontal)
            .padding(.leading)
        }
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .background {
            Color.gray
                .opacity(0.08)
                .ignoresSafeArea(.container, edges: .vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var userImage: some View {
        Image(systemName: "person")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 65, height: 65)
            .padding(.bottom)
    }
    private var userFullName: some View {
        VStack(alignment: .leading) {
            Text("Имя и фамилия")
                .font(.caption)
            
            HStack {
                Text(dataVM.currentProfile?.firstName ?? "f name")
                Text(dataVM.currentProfile?.lastName ?? "l name")
            }
            .font(.title3)
            .bold()
        }
    }
    private var userEmail: some View {
        VStack(alignment: .leading) {
            Text("Ваша почта")
                .font(.caption)
            
            Text(dataVM.currentProfile?.email ?? "email")
                .font(.title3)
                .bold()
        }
    }
    private var userDisease: some View {
        VStack(alignment: .leading) {
            Text("Заболевание")
                .font(.caption)
            
            Text(dataVM.currentProfile?.disease ?? "disease")
                .font(.title3)
                .bold()
        }
    }
    private var sideMenuButtons: some View {
        VStack {
            Divider()
            HStack {
                exitButton
                Spacer()
                aboutButton
            }
            .padding([.top, .horizontal])
        }
    }
}

//MARK: - MAIN VIEWS
extension Main {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                showSideMenuButton
                Spacer()
                addItemButton
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            
            Capsule()
                .frame(height: 1)
                .foregroundColor(.primary)
                .padding(.horizontal, 5)
            
            HStack {
                Text("Препарат")
                Spacer()
                Text("Дата приёма")
            }
            .padding(10)
            .foregroundColor(.primary)
            .font(.caption)
            .bold()
        }
    }
    private var mainView: some View {
        VStack {
            header
            if dataVM.currentProfile != nil {
                List {
                    ForEach(drugVM.drugs.filter{$0.userUID == dataVM.currentProfile!.uid}) { drug in
                        NavigationLink(destination: DetailsView(drug: drug)) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("\(drug.title ?? "")")
                                    Spacer()
                                    Text("\(Date.getDateAndTime(date: drug.date ?? Date()))")
                                }
                                

                                HStack {
                                    Text("Дозировка: \(drug.dosage) мг")
                                    Spacer()
                                    Text("Самочувствие: \(drug.efficiency)")
                                }
                                .font(.caption2)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .onDelete(perform: drugVM.deleteValue)
                }
                .listStyle(.plain)
            }
            Spacer()
        }
    }
}


//MARK: - BUTTONS
extension Main {
    //SIDE MENU BUTTONS
    private var exitButton: some View {
        Button(action: {
            Task {
                do {
                    try? AuthenticationManager.shared.userSignOut()
                    withAnimation(.default) {
                        self.showMenu = false
                        self.showSignInScreen = true
                    }
                }
            }
        }) {
            VStack {
                Image(systemName: "figure.walk.arrival")
                    .font(.title2)
                
                Text("Выйти")
                    .font(.caption)
            }
            .foregroundColor(.primary)
        }
    }
    private var aboutButton: some View {
        Button(action: {
            //
        }) {
            VStack {
                Image(systemName: "questionmark.circle")
                    .font(.title)
                
                Text("О программе")
                    .font(.caption)
            }
            .foregroundColor(.primary)
        }
    }
    
    //HEADER BUTTONS
    private var showSideMenuButton: some View {
        Button(action: {
            withAnimation(.default) {
                showMenu.toggle()
            }
        }) {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .foregroundColor(.primary)
        }
    }
    private var addItemButton: some View {
        Button(action: {
            self.showAddItemView.toggle()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.primary)
                .font(.headline)
        }
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                Main(showSignInScreen: .constant(false))
                    .preferredColorScheme(.light)
                    .environmentObject(DataVM())
                    .environmentObject(DrugVM())
            }
            
            NavigationStack {
                Main(showSignInScreen: .constant(false))
                    .preferredColorScheme(.dark)
                    .environmentObject(DataVM())
                    .environmentObject(DrugVM())
            }
        }
    }
}



/*
 @State private var lastStoredOffset: CGFloat = 0
 
 @GestureState private var gestureOffset: CGFloat = 0

 
         .gesture(DragGesture()
             .updating($gestureOffset, body: { value, out, _ in out = value.translation.width })
             .onEnded(onEnd(value:)))
         .navigationBarHidden(true)
         .navigationBarTitleDisplayMode(.inline)
         .animation(.easeOut, value: offset == 0)
         .onChange(of: showMenu) { newValue in
             if showMenu && offset == 0 {
                 lastStoredOffset = offset
             }
 
             if !showMenu && offset == lastStoredOffset {
                 offset = 0
                 lastStoredOffset = 0
             }
         }
         .onChange(of: gestureOffset) { _ in
             onChange()
         }
 
 //MARK: - METHODS
 extension Main {
     func onEnd(value: DragGesture.Value) {
         let sideBarWidth = getRect().width - 90
         
         let translation = value.translation.width
         
         withAnimation(.default) {
             if translation > 0 {
                 if translation > (sideBarWidth / 2) {
                     offset = sideBarWidth
                     showMenu = true
                 } else {
                     
                     if offset == sideBarWidth {
                         return
                     }
                     
                     offset = 0
                     showMenu = false
                 }
             } else {
                 if -translation > (sideBarWidth / 2) {
                     offset = 0
                     showMenu = false
                 } else {
                     
                     if offset == 0 || !showMenu {
                         return
                     }
                     
                     offset = sideBarWidth
                     showMenu = true
                 }
             }
         }

         lastStoredOffset = offset
     }
     func onChange() {
         let sideBarWidth = getRect().width - 90

         offset = (gestureOffset != 0) ? (gestureOffset + lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset) : offset
     }
 }
 */
