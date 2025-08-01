//
//  FormTextField.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI

struct FormTextField: View {
    @Binding var text: String
    @Binding var errorMessage: String
    
    var title: String
    var supportingText: String?
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var showTopLabel: Bool {
        isFocused
    }

    var showErrorText: Bool {
        !errorMessage.isEmpty && !isFocused
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Offset.extraSmall) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(borderColor, lineWidth: 1)
                    .background(Color.appBackground)

                VStack(alignment: .leading, spacing: 1) {
                    if showTopLabel {
                        Text(title)
                            .font(.appFont(weight: .regular, size: 12))
                            .foregroundStyle(text.isEmpty ? textColor : .appFieldText)
                    }
                    
                    TextField(title, text: $text)
                        .font(.appFont(weight: .regular, size: 16))
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .focused($isFocused)
                        .onChange(of: isFocused) {
                            if isFocused {
                                errorMessage = ""
                            }
                        }
                }
                .padding(.horizontal, Offset.standard)
                .padding(.vertical, showTopLabel ? 8 : 16)
            }
            .frame(height: FieldHeight.standard)

            if showErrorText {
                Text(errorMessage)
                    .font(.appFont(weight: .regular, size: 12))
                    .foregroundStyle(.appError)
                    .padding(.leading, Offset.standard)
            } else {
                if let supportingText = supportingText {
                    Text(supportingText)
                        .font(.appFont(weight: .regular, size: 12))
                        .foregroundStyle(.appFieldText)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    private var borderColor: Color {
        if isFocused {
            return .appSecondary
        } else if !errorMessage.isEmpty {
            return .appError
        } else {
            return .appFieldBorder
        }
    }
    
    private var textColor: Color {
        if isFocused {
            return .appSecondary
        } else if !errorMessage.isEmpty {
            return .appError
        } else {
            return .appFieldText
        }
    }
}
