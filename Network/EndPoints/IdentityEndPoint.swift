//
//  IdentityEndPoint.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

enum IdentityEndPoint {
    case token
    case users(page: Int, count: Int)
    case positions
    case createUser(CreateUserForm)
}

extension IdentityEndPoint: EndPointType {

    var path: String {
        switch self {
        case .token:      return "token"
        case .users:      return "users"
        case .positions:  return "positions"
        case .createUser: return "users"
        }
    }

    var parameters: RequestParams {
        switch self {
        case let .users(page, count):
            return .query(AnyEncodable(UsersQuery(page: page, count: count)))

        case .token, .positions:
            return .none

        case let .createUser(form):
            return .multipart { body in
                body.addField(name: "name", value: form.name)
                body.addField(name: "email", value: form.email.lowercased())
                body.addField(name: "phone", value: form.phone)
                
                if let positionId = form.positionId {
                    body.addField(name: "position_id", value: String(positionId))
                }

                if let photoData = form.photoData {
                    body.addFile(
                        name: "photo",
                        filename: form.filename,
                        mimeType: form.mimeType,
                        data: photoData
                    )
                }
            }
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .token, .users, .positions: return .get
        case .createUser:                return .post
        }
    }

    var apiVersion: APIVersion { .v1 }
    
    var requiresToken: Bool {
        switch self {
        case .token: return false
        default:     return true
        }
    }
    
    var allowsValidationFailure: Bool {
        switch self {
        case .createUser:
            return true
        default:
            return false
        }
    }
}
