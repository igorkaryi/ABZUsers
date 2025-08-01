//
//  UserRowView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    private let avatarSize: CGFloat = 50

    var body: some View {
        VStack(spacing: Offset.medium) {
            HStack(alignment: .top, spacing: Offset.standard) {
                avatar

                VStack(alignment: .leading, spacing: Offset.small) {
                    VStack(alignment: .leading, spacing: Offset.extraSmall) {
                        Text(user.name)
                            .font(.appFont(weight: .regular, size: 18))
                            .foregroundStyle(.appMainText)

                        Text(user.position)
                            .font(.appFont(weight: .regular, size: 14))
                            .foregroundStyle(.appSecondaryText)
                            .lineLimit(1)
                    }

                    Text(user.email)
                        .font(.appFont(weight: .regular, size: 14))
                        .foregroundStyle(.appMainText)
                        .lineLimit(1)

                    Text(user.phone)
                        .font(.appFont(weight: .regular, size: 14))
                        .foregroundStyle(.appMainText)
                        .lineLimit(1)
                    
                    ListSeparator()
                        .padding(.top, Offset.medium)
                }

                Spacer()
            }
        }
    }

    @ViewBuilder
    private var avatar: some View {
        if let urlString = user.photo, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure(_):
                    placeholder
                case .empty:
                    Color.appTabbarBackground
                @unknown default:
                    Color.appTabbarBackground
                }
            }
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(Circle())
        } else {
            placeholder
                .frame(width: avatarSize, height: avatarSize)
                .clipShape(Circle())
        }
    }

    private var placeholder: some View {
        Circle()
            .fill(Color.appSecondaryText)
            .overlay(
                Image(systemName: "person.fill")
                    .imageScale(.medium)
                    .foregroundColor(.secondary)
            )
    }
}
