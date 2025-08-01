//
//  TokenProvider.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation
import Combine

final class TokenProvider {
    private let network: NetworkServicing
    private let tokenStorage: TokenStorageProtocol
    private let tokenEndpoint: IdentityEndPoint

    private var refreshSubject: PassthroughSubject<String, Error>?
    private var cancellables = Set<AnyCancellable>()
    private let lock = NSLock()

    init(network: NetworkServicing,
         tokenStorage: TokenStorageProtocol,
         tokenEndpoint: IdentityEndPoint) {
        self.network = network
        self.tokenStorage = tokenStorage
        self.tokenEndpoint = tokenEndpoint
    }

    func validToken() -> AnyPublisher<String, Error> {
        if let token = tokenStorage.token {
            return Just(token).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return refresh()
    }

    func refresh() -> AnyPublisher<String, Error> {
        lock.lock()
        if let existing = refreshSubject {
            lock.unlock()
            return existing.eraseToAnyPublisher()
        }
        let subject = PassthroughSubject<String, Error>()
        refreshSubject = subject
        lock.unlock()

        (network.request(endPoint: tokenEndpoint) as AnyPublisher<TokenResponse, Error>)
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let err) = completion {
                    self.finishRefresh(with: .failure(err))
                }
            } receiveValue: { [weak self] res in
                guard let self else { return }
                self.tokenStorage.token = res.token
                self.finishRefresh(with: .success(res.token))
            }
            .store(in: &cancellables)

        return subject.eraseToAnyPublisher()
    }

    private func finishRefresh(with result: Result<String, Error>) {
        lock.lock(); defer { lock.unlock() }
        switch result {
        case .success(let token):
            refreshSubject?.send(token)
            refreshSubject?.send(completion: .finished)
        case .failure(let err):
            refreshSubject?.send(completion: .failure(err))
        }
        refreshSubject = nil
    }
}
