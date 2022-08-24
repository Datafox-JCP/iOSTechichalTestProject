//
//  PeopleView.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 22/08/22.
//

import SwiftUI

struct PeopleView: View {
    
    @StateObject private var vm = PeopleViewModel()
    @State private var shouldShowCreate = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                
                ScrollView {
                    LazyVGrid(columns: columns,
                              spacing: 16) {
                        ForEach(vm.users, id:\.id) { user in
                            NavigationLink {
                                DetailView(userID: user.id)
                            } label: {
                                PersonItemView(user: user)
                            }
                        } // ForEach
                    }
                } // Scroll
                .padding()
            } // ZStack
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    create
                }
            }
            .onAppear {
                vm.fetchUsers()
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView()
            }
        } // Navigation
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

private extension PeopleView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var create: some View {
        Button {
            shouldShowCreate.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                    )
        }
    }
}