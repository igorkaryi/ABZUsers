//
//  RequestParams.swift
//  ABZUsers
//
//  Created by Igor Karyi on 31.07.2025.
//

import Foundation

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    public init<T: Encodable>(_ value: T) { _encode = value.encode }
    public func encode(to encoder: Encoder) throws { try _encode(encoder) }
}

public typealias MultipartBuilder = (inout MultipartBody) -> Void

public enum RequestParams {
    case none
    case query(AnyEncodable)
    case json(AnyEncodable)
    case multipart(MultipartBuilder)

    public static func fromQuery<T: Encodable>(_ value: T) -> Self { .query(AnyEncodable(value)) }
    public static func fromJSON<T: Encodable>(_ value: T) -> Self { .json(AnyEncodable(value)) }
}
