//
//  MultipartEncoder.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

public struct MultipartBody {
    public let boundary: String = "----abz-\(UUID().uuidString)"

    private var parts: [Data] = []

    public init() {}

    public mutating func addField(name: String, value: String) {
        var d = Data()
        d.append("--\(boundary)\r\n")
        d.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        d.append("\(value)\r\n")
        parts.append(d)
    }

    public mutating func addField(name: String, value: CustomStringConvertible) {
        addField(name: name, value: value.description)
    }

    public mutating func addOptionalField(name: String, value: String?) {
        guard let v = value, !v.isEmpty else { return }
        addField(name: name, value: v)
    }

    public mutating func addFields(_ fields: [String: String]) {
        for (k, v) in fields { addField(name: k, value: v) }
    }

    public mutating func addFile(name: String,
                                 filename: String,
                                 mimeType: String,
                                 data: Data) {
        var d = Data()
        d.append("--\(boundary)\r\n")
        d.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        d.append("Content-Type: \(mimeType)\r\n\r\n")
        d.append(data)
        d.append("\r\n")
        parts.append(d)
    }

    public func build() -> (data: Data, contentType: String) {
        var body = Data()
        parts.forEach { body.append($0) }
        body.append("--\(boundary)--\r\n")
        let contentType = "multipart/form-data; boundary=\(boundary)"
        return (body, contentType)
    }
}
