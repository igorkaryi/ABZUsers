//
//  EndPoint.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

enum EndPoint {}

extension EndPoint: EndPointType {
    
    var path: String {
        return ""
    }

    var parameters: Encodable? {
        return nil
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var apiVersion: APIVersion {
        return .v1
    }
}
