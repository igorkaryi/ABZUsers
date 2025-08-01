//
//  ABZUsersApp.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

@main
struct ABZUsersApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(networkMonitor)
        }
    }
}
