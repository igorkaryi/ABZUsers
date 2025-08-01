//
//  UsersViewModel.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import SwiftUI
import Combine

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMore = true

    private var page = 1
    private let count = 6
    private var bag = Set<AnyCancellable>()
    private let network: NetworkServicing

    // трекаємо ID, щоб не з’являлися дублікати при пагінації
    private var seenIDs = Set<Int>()

    init(environment: AppEnvironment = .prod, tokenEndpoint: IdentityEndPoint = .token) {
        let storage = TokenStorage()
        let api = APIService(tokenStorage: storage, environment: environment, tokenEndpoint: tokenEndpoint)
        self.network = api
    }

    func loadInitial() {
        users.removeAll()
        seenIDs.removeAll()
        page = 1
        hasMore = true
        loadMore()
    }

    func loadMore() {
        guard !isLoading, hasMore else { return }
        isLoading = true
        errorMessage = nil

        (network.request(endPoint: .users(page: page, count: count)) as AnyPublisher<UsersPage, Error>)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion { self.errorMessage = err.localizedDescription }
            } receiveValue: { [weak self] res in
                guard let self else { return }

                let fresh = res.users.filter { user in
                    guard !self.seenIDs.contains(user.id) else { return false }
                    self.seenIDs.insert(user.id)
                    return true
                }

                self.users.append(contentsOf: fresh)

                self.hasMore = res.page < res.total_pages
                if self.hasMore { self.page += 1 }
            }
            .store(in: &bag)
    }

    /// Викликати, коли елемент з’явився у в’ю — якщо це останні елементи, підвантажуємо наступну сторінку
    func onItemAppear(_ user: User) {
        guard hasMore, !isLoading else { return }
        if let idx = users.firstIndex(where: { $0.id == user.id }) {
            // Тригеримо прелоад, коли користувач у нижній «третині» списку
            let thresholdIndex = users.index(users.endIndex, offsetBy: -3, limitedBy: users.startIndex) ?? users.startIndex
            if idx >= thresholdIndex {
                loadMore()
            }
        }
    }
}
