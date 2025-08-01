//
//  CreateUserForm.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation

struct UsersQuery: Encodable {
    let page: Int
    let count: Int
}

struct CreateUserForm {
    let name: String
    let email: String
    let phone: String
    let positionId: Int?
    let photoData: Data?
    let filename: String
    let mimeType: String
}
