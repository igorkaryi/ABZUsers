//
//  APIError.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation

struct APIErrorPayload: Decodable { let message: String }

enum APIError: Error, Equatable {
    case unauthorized
    case server(message: String, code: Int)
    case unknown(String)
}
