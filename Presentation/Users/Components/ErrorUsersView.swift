//
//  ErrorUsersView.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI

struct ErrorUsersView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack {
            Spacer()
            
            StateView(
                imageName: "no_users_yet_icon",
                message: message.localizedString
            )
            PrimaryButton(
                title: "try_again".localizedString,
                isEnabled: true,
                action: onRetry
            )
            .padding(.top, 8)
            
            Spacer()
        }
    }
}
