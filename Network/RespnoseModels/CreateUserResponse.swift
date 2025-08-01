//
//  CreateUserResponse.swift
//  ABZUsers
//
//  Created by Igor Karyi on 01.08.2025.
//

import Foundation

struct CreateUserResponse: Decodable {
    let success: Bool
    let userId: Int?
    let message: String?
    let fails: FieldErrors?
    
    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case message
        case fails
    }
}

struct FieldErrors: Decodable {
    let email: [String]?
    let phone: [String]?
    let name: [String]?
    let photo: [String]?
}

extension FieldErrors {
    var emailError: String? { email?.first }
    var phoneError: String? { phone?.first }
    var nameError: String? { name?.first }
    var photoError: String? { photo?.first }
}
