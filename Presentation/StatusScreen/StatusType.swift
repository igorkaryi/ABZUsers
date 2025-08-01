//
//  StatusType.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

enum StatusType {
    case userSuccessfullyRegistered
    case emailAlreadyRegistered
    case noInternetConnection
    
    var imageName: String {
        switch self {
        case .userSuccessfullyRegistered: 
            return "user_successfully_registered_icon"
        case .emailAlreadyRegistered:
            return "email_already_registered_icon"
        case .noInternetConnection:
            return "no_internet_connection_icon"
        }
    }

    var message: String {
        switch self {
        case .userSuccessfullyRegistered:
            return "user_successfully_registered"
        case .emailAlreadyRegistered:
            return "email_already_registered"
        case .noInternetConnection:
            return "there_is_no_internet_connection"
        }
    }

    var buttonTitle: String {
        switch self {
        case .userSuccessfullyRegistered:
            return "got_it"
        default:
            return "try_again"
        }
    }
    
    var needShowCloseButton: Bool {
        switch self {
        case .noInternetConnection:
            return false
        default:
            return true
        }
    }
}
