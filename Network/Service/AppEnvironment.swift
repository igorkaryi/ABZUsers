//
//  AppEnvironment.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

enum AppEnvironment {
    case prod

    var baseUrl: String {
        switch self {
        case .prod:
            return Config.apiEndpoint
        }
    }
}
