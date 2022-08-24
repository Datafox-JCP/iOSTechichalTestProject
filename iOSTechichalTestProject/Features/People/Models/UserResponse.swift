    //
    //  UserResponse.swift
    //  iOSTechichalTestProject
    //
    //  Created by Juan Hernandez Pazos on 13/08/22.
    //

import Foundation

    // MARK: - UsersResponse
struct UsersResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
