//
//  MainTabView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTab = .users
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    @State private var showNoInternet = false

    var body: some View {
        VStack(spacing: Offset.zero) {
            ZStack {
                switch selectedTab {
                case .users:
                    UsersScreen()
                case .signup:
                    SignUpScreen()
                }
            }

            HStack {
                TabBarItemView(
                    tab: .users,
                    isSelected: selectedTab == .users,
                    action: { selectedTab = .users }
                )

                TabBarItemView(
                    tab: .signup,
                    isSelected: selectedTab == .signup,
                    action: { selectedTab = .signup }
                )
            }
            .padding(.horizontal, Offset.large)
            .padding(.top, Offset.groupBox)
            .padding(.bottom, Offset.large)
            .background(.appTabbarBackground)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: networkMonitor.isConnected) {
            showNoInternet = !networkMonitor.isConnected
        }
        .fullScreenCover(isPresented: $showNoInternet) {
            StatusScreen(type: .noInternetConnection) {
                networkMonitor.forceCheck()
            }
        }
    }
}
