//
//  UsersContentView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct UsersContentView: View {
    let users: [User]
    let isLoading: Bool
    let errorMessage: String?
    let hasMore: Bool
    let onRetry: () -> Void
    let onLoadMoreItemAppear: (User) -> Void

    var body: some View {
        Group {
            if isLoading && users.isEmpty {
                LoadingUsersView()
            } else if let msg = errorMessage, users.isEmpty {
                ErrorUsersView(message: msg, onRetry: onRetry)
            } else if users.isEmpty {
                EmptyUsersView()
            } else {
                UsersListView(
                    users: users,
                    isLoadingMore: isLoading,
                    hasMore: hasMore,
                    onItemAppear: onLoadMoreItemAppear
                )
            }
        }
    }
}
