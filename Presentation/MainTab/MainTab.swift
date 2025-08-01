//
//  MainTab.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

enum MainTab {
    case users
    case signup
    
    var title: String {
        switch self {
        case .users:
            return "users"
        case .signup:
            return "sign_up"
        }
    }
    
    var iconName: String {
        switch self {
        case .users:
            return "tab_users_icon"
        case .signup:
            return "tab_sign_up_icon"
        }
    }
    
    var iconSelectedName: String {
        switch self {
        case .users:
            return "tab_users_selected_icon"
        case .signup:
            return "tab_sign_up_selected_icon"
        }
    }
}
