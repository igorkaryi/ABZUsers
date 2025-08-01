//
//  UsersListView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct UsersListView: View {
    let users: [User]
    let isLoadingMore: Bool
    let hasMore: Bool
    let onItemAppear: (User) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Offset.standard) {
                ForEach(users) { user in
                    UserRowView(user: user)
                        .padding(.leading, Offset.standard)
                        .onAppear { onItemAppear(user) }
                }

                if hasMore { Color.clear.frame(height: 1) }
            }
            .padding(.top, Offset.medium)
        }
        .safeAreaInset(edge: .bottom) {
            if isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.appSecondaryText)
                    Spacer()
                }
                .padding(.vertical, Offset.standard)
                .background(.appBackground)
            }
        }
    }
}
