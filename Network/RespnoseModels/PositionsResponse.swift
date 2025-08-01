//
//  PositionsResponse.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation

struct UserPosition: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct PositionsResponse: Decodable {
    let success: Bool
    let positions: [UserPosition]
}
