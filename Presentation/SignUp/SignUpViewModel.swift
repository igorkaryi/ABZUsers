//
//  SignUpViewModel.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI
import Combine

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var errorName = ""
    
    @Published var email = ""
    @Published var errorEmail = ""
    
    @Published var phone = ""
    @Published var errorPhone = ""
    
    @Published var selectedImage: UIImage?
    @Published var errorPhoto = ""
    
    @Published var selectedPositionId: Int?
    
    var isEnabledButton: Bool {
        !name.isEmpty || !email.isEmpty || !phone.isEmpty || selectedImage != nil
    }

    @Published var isSubmitting = false

    @Published var showSuccessScreen = false
    @Published var showUserExistScreen = false
    
    @Published var positions: [UserPosition] = []
    @Published var isLoadingPositions = false
    @Published var positionsError: String?

    private let api: APIService
    private var bag = Set<AnyCancellable>()

    init(environment: AppEnvironment = .prod) {
        let storage = TokenStorage()
        self.api = APIService(tokenStorage: storage, environment: environment, tokenEndpoint: .token)
    }
    
    func loadPositions() {
        guard !isLoadingPositions else { return }
        isLoadingPositions = true
        positionsError = nil
        
        api.request(endPoint: .positions)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                self.isLoadingPositions = false
                if case .failure(let err) = completion {
                    self.positionsError = err.localizedDescription
                }
            } receiveValue: { [weak self] (res: PositionsResponse) in
                guard let self else { return }
                
                self.positions = res.positions
                self.selectedPositionId = res.positions.first?.id
            }
            .store(in: &bag)
    }

    func submit() {
        isSubmitting = true
        
        errorName = ""
        errorEmail = ""
        errorPhone = ""
        errorPhoto = ""

        let form = CreateUserForm(
            name: name,
            email: email,
            phone: phone,
            positionId: selectedPositionId,
            photoData: imageData,
            filename: "photo.jpg",
            mimeType: "image/jpeg"
        )

        api.request(endPoint: .createUser(form))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                self.isSubmitting = false
                
            } receiveValue: { [weak self] (result: CreateUserResponse) in
                guard let self else { return }
                
                if result.success {
                    self.showSuccessScreen = true
                    self.name = ""
                    self.email = ""
                    self.phone = ""
                    self.selectedImage = nil
                    self.selectedPositionId = nil
                } else {
                    if let fails = result.fails {
                        if let nameError = fails.nameError {
                            self.errorName = nameError
                        }
                        
                        if let emailError = fails.emailError {
                            self.errorEmail = emailError
                        }
                        
                        if let phoneError = fails.phoneError {
                            self.errorPhone = phoneError
                        }
                        
                        if let photoError = fails.photoError {
                            self.errorPhoto = photoError
                        }
                    } else {
                        showUserExistScreen = true
                    }
                }
            }
            .store(in: &bag)
    }
    
    private var imageData: Data? {
        guard let image = selectedImage,
              let jpeg = image.jpegData(compressionQuality: 0.9) else {
            return nil
        }
        
        return jpeg
    }
}
