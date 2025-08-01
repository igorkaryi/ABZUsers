//
//  APIService.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation
import Combine

protocol NetworkServicing {
    func request<T: Decodable>(endPoint: IdentityEndPoint) -> AnyPublisher<T, Error>
}

final class APIService: ObservableObject, NetworkServicing {

    private let base: BaseAPIService
    private let tokens: TokenProvider

    init(tokenStorage: TokenStorageProtocol = TokenStorage(),
         environment: AppEnvironment,
         tokenEndpoint: IdentityEndPoint = .token) {

        self.base = BaseAPIService(tokenStorage: tokenStorage, environment: environment)
        self.tokens = TokenProvider(network: base, tokenStorage: tokenStorage, tokenEndpoint: tokenEndpoint)
    }

    func request<T: Decodable>(endPoint: IdentityEndPoint) -> AnyPublisher<T, Error> {
        guard endPoint.requiresToken else {
            return base.request(endPoint: endPoint)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

        return tokens.validToken()
            .flatMap { _ in
                self.base.request(endPoint: endPoint) as AnyPublisher<T, Error>
            }
            .catch { error -> AnyPublisher<T, Error> in
                guard let apiError = error as? APIError, apiError == .unauthorized else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return self.tokens.refresh()
                    .flatMap { _ in self.base.request(endPoint: endPoint) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
