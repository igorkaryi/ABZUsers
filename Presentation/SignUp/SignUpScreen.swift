//
//  SignUpScreen.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import SwiftUI
import SwiftUI

struct SignUpScreen: View {
    @StateObject private var viewModel = SignUpViewModel()

    var body: some View {
        VStack(spacing: Offset.medium) {
            HeaderView(
                title: String(
                    format: "working_with_request".localizedString,
                    HTTPMethod.post.rawValue
                )
            )
            .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: Offset.medium) {
                    FormTextField(
                        text: $viewModel.name,
                        errorMessage: $viewModel.errorName,
                        title: "your_name".localizedString
                    )
                    
                    FormTextField(
                        text: $viewModel.email,
                        errorMessage: $viewModel.errorEmail,
                        title: "email".localizedString,
                        keyboardType: .emailAddress
                    )
                    
                    FormTextField(
                        text: $viewModel.phone,
                        errorMessage: $viewModel.errorPhone,
                        title: "phone".localizedString,
                        supportingText: "phone_supporting_text".localizedString,
                        keyboardType: .numbersAndPunctuation
                    )

                    PositionSelectionView(
                        positions: viewModel.positions,
                        selectedPositionId: $viewModel.selectedPositionId
                    )

                    PhotoPickerField(
                        title: viewModel.selectedImage == nil
                            ? "upload_your_photo".localizedString
                            : "photo_selected".localizedString,
                        errorMessage: $viewModel.errorPhoto,
                        image: $viewModel.selectedImage
                    )
                    .padding(.vertical, Offset.medium)
                    
                    PrimaryButton(
                        title: "sign_up".localizedString,
                        isEnabled: viewModel.isEnabledButton
                    ) {
                        viewModel.submit()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.top, Offset.extraSmall)
                .padding(.horizontal, Offset.standard)
                .padding(.bottom, Offset.large)
            }
        }
        .background(.appBackground)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            viewModel.loadPositions()
        }
        .fullScreenCover(isPresented: $viewModel.showSuccessScreen) {
            StatusScreen(type: .userSuccessfullyRegistered) {
                viewModel.showSuccessScreen = false
            }
        }
        .fullScreenCover(isPresented: $viewModel.showUserExistScreen) {
            StatusScreen(type: .emailAlreadyRegistered) {
                viewModel.showUserExistScreen = false
            }
        }
        
        if viewModel.isSubmitting {
            FullScreenLoader()
        }
    }
}
