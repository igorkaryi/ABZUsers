//
//  PrimaryButton.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    @GestureState private var isPressed = false

    var body: some View {
        Text(title)
            .font(.appFont(weight: .semiBold, size: 18))
            .foregroundStyle(textColor)
            .padding(.vertical, Offset.secondary)
            .padding(.horizontal, 39)
            .background(backgroundColor)
            .cornerRadius(CornerRadius.large)
            .gesture(
                DragGesture(minimumDistance: Offset.zero)
                    .updating($isPressed) { _, state, _ in state = true }
                    .onEnded { _ in
                        if isEnabled {
                            action()
                        }
                    }
            )
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    private var backgroundColor: Color {
        if !isEnabled {
            return .appPrimaryButtonDisabled
        } else if isPressed {
            return .appPrimaryButtonPressed
        } else {
            return .appPrimary
        }
    }

    private var textColor: Color {
        if !isEnabled {
            return .appPrimaryButtonDisabledText
        } else {
            return .appMainText
        }
    }
}
