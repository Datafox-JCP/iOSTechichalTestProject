//
//  ContentView.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 27/07/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                print("👉🏻 Users response")
                dump(
                    try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
                )
                print("👉🏻 Single users Response")
                dump(
                    try? StaticJSONMapper.decode(file: "SingleUserStaticData", type: UserDetailResponse.self)
                )
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
