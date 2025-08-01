//
//  UsersScreen.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct UsersScreen: View {
    @StateObject private var viewModel = UsersViewModel()

    var body: some View {
        VStack(spacing: Offset.zero) {
            HeaderView(
                title: String(
                    format: "working_with_request".localizedString,
                    HTTPMethod.get.rawValue
                )
            )
            .padding(.top)

            UsersContentView(
                users: viewModel.users,
                isLoading: viewModel.isLoading,
                errorMessage: viewModel.errorMessage,
                hasMore: viewModel.hasMore,
                onRetry: { viewModel.loadInitial() },
                onLoadMoreItemAppear: { user in viewModel.onItemAppear(user) }
            )

            Spacer(minLength: 0)
        }
        .background(.appBackground)
        .ignoresSafeArea(edges: .bottom)
        .onAppear { viewModel.loadInitial() }
    }
}
