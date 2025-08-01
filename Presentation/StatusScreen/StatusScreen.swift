//
//  StatusScreen.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct StatusScreen: View {
    let type: StatusType
    let onAction: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: Offset.medium) {
                Spacer()

                StateView(
                    imageName: type.imageName,
                    message: type.message.localizedString
                )

                PrimaryButton(
                    title: type.buttonTitle.localizedString,
                    isEnabled: true,
                    action: onAction
                )

                Spacer()
            }
            .padding(.horizontal, Offset.standard)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .ignoresSafeArea()
        .safeAreaInset(edge: .top) {
            if type.needShowCloseButton {
                HStack {
                    Spacer()

                    Button(action: onAction) {
                        Image("close_icon")
                            .resizable()
                            .frame(width: Offset.medium, height: Offset.medium)
                            .padding(.trailing, Offset.medium)
                    }
                }
                .frame(height: 44)
                .background(Color.clear)
            }
        }
    }
}
