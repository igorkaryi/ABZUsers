//
//  EndPointType.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    func baseURL(_ environment: AppEnvironment) -> URL
    var apiVersion: APIVersion { get }
}

extension EndPointType {
    
    func baseURL(_ environment: AppEnvironment) -> URL {
        let urlString = "\(environment.baseUrl)/\(apiVersion.rawValue)/\(path)"
        guard let url = URL(string: urlString) else {
            fatalError("baseURL could not be configured.")
        }
        
        return url
    }
}
