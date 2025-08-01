//
//  User.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation

struct UsersPage: Decodable {
    let users: [User]
    let page: Int
    let total_pages: Int
}

struct User: Decodable, Identifiable {
    let id: Int
    let name: String
    let position: String
    let email: String
    let phone: String
    let photo: String?
}
