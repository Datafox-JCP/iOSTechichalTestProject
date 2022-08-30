//
//  iOSTechichalTestProjectApp.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 27/07/22.
//

import SwiftUI

@main
struct iOSTechichalTestProjectApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
                SettingsView()
                    .tabItem {
                        Symbols.gear
                        Text("Settings")
                    }
            }
        }
    }
}
