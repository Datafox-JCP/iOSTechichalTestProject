//
//  Models.swift
//  iOSTechichalTestProject
//
//  Created by Juan Hernandez Pazos on 13/08/22.
//

import Foundation

    // MARK: - User
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

    // MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
