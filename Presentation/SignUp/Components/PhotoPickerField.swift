//
//  PhotoPickerField.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI
import PhotosUI

struct PhotoPickerField: View {
    let title: String
    @Binding var errorMessage: String
    @Binding var image: UIImage?

    @State private var showActionSheet = false
    @State private var showCameraPicker = false
    @State private var showPhotoLibraryPicker = false

    var isError: Bool {
        !errorMessage.isEmpty && image == nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Offset.extraSmall) {
            HStack {
                Text(title)
                    .font(.appFont(weight: .regular, size: 16))
                    .foregroundStyle(isError ? Color.appError : Color.appFieldText)

                Spacer()

                SecondaryTextButton(title: "upload".localizedString, isEnabled: true) {
                    showActionSheet = true
                }
            }
            .padding()
            .frame(height: FieldHeight.standard)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(isError ? Color.appError : Color.appFieldBorder, lineWidth: 1)
            )

            if isError {
                Text("photo_is_required".localizedString)
                    .font(.appFont(weight: .regular, size: 12))
                    .foregroundStyle(.appError)
                    .padding(.horizontal, Offset.standard)
            }
        }

        .confirmationDialog("choose_how_you_want_to_add_a_photo".localizedString, isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("camera".localizedString) {
                showCameraPicker = true
            }
            Button("gallery".localizedString) {
                showPhotoLibraryPicker = true
            }
            Button("cancel".localizedString, role: .cancel) {}
        }

        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera, image: $image)
        }

        .sheet(isPresented: $showPhotoLibraryPicker) {
            ImagePicker(sourceType: .photoLibrary, image: $image)
        }
    }
}
