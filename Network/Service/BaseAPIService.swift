//
//  BaseAPIService.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation
import Combine

final class BaseAPIService: NetworkServicing {
    
    let tokenStorage: TokenStorageProtocol
    let environment: AppEnvironment
    
    init(tokenStorage: TokenStorageProtocol, environment: AppEnvironment) {
        self.tokenStorage = tokenStorage
        self.environment = environment
    }
    
    func request<T: Decodable>(endPoint: IdentityEndPoint) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: endPoint.baseURL(environment))
        request.httpMethod = endPoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if endPoint.requiresToken, let token = tokenStorage.token {
            request.setValue(token, forHTTPHeaderField: "Token")
        }

        switch endPoint.parameters {
        case .none:
            break

        case .query(let enc):
            request = encodeGetParams(request, parameters: enc)

        case .json(let enc):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(enc)

        case .multipart(let fill):
            var body = MultipartBody()
            fill(&body)
            let built = body.build()
            request.setValue(built.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = built.data
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> (Data, HTTPURLResponse) in
                guard let http = output.response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
                self.logResponse(output.data, response: http)
                if http.statusCode == 401 { throw APIError.unauthorized }
                if !(200...299).contains(http.statusCode) {
                    if endPoint.allowsValidationFailure,
                       (try? JSONDecoder().decode(T.self, from: output.data)) != nil {
                        return (output.data, http)
                    }

                    if let payload = try? JSONDecoder().decode(APIErrorPayload.self, from: output.data) {
                        throw APIError.server(message: payload.message, code: http.statusCode)
                    } else {
                        throw APIError.server(message: "HTTP \(http.statusCode)", code: http.statusCode)
                    }
                }
                return (output.data, http)
            }
            .tryMap { data, http -> T in
                if http.statusCode == 204 || data.isEmpty {
                    if T.self == EmptyResponse.self, let empty = EmptyResponse() as? T { return empty }
                    throw APIError.unknown("Порожня відповідь від сервера")
                }
                return try JSONDecoder().decode(T.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    
    private func encodeGetParams(_ request: URLRequest, parameters: Encodable) -> URLRequest {
        var request = request
        do {
            let data = try JSONEncoder().encode(parameters)
            guard let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { return request }
            
            var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            var items: [URLQueryItem] = components?.queryItems ?? []
            
            for (key, value) in dict {
                if let array = value as? [Any] {
                    items.append(contentsOf: array.map { URLQueryItem(name: "\(key)[]", value: "\($0)") })
                } else {
                    items.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            components?.queryItems = items
            request.url = components?.url
        } catch {
            print("GET param encode error: \(error)")
        }
        return request
    }
    
    private func logRequest(_ request: URLRequest, parameters: Encodable?) {
        print("\n--- Request ---")
        print("URL: \(request.url?.absoluteString ?? "")")
        print("Method: \(request.httpMethod ?? "-")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let parameters = parameters {
            do {
                let data = try JSONEncoder().encode(parameters)
                let json = String(data: data, encoding: .utf8) ?? "nil"
                print("Parameters: \(json)")
            } catch {
                print("Param encode error: \(error)")
            }
        }
        print("Time: \(Date())")
        print("--- End Request ---\n")
    }
    
    private func logResponse(_ data: Data, response: HTTPURLResponse) {
        print("\n--- Response ---")
        print("URL: \(response.url?.absoluteString ?? "")")
        print("Status Code: \(response.statusCode)")
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("Body: \n\(prettyString)")
        } else {
            print("Raw: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
        }
        print("Time: \(Date())")
        print("--- End Response ---\n")
    }
}
