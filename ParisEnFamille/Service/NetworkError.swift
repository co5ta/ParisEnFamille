//
//  NetworkError.swift
//  ParisEnFamille
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// Management of possible error in a network request
enum NetworkError: Error {
    
    // List of possible errors
    case url
    case client(Error)
    case server(URLResponse?)
    case noData
    case decoding(Error?)
    case noResult
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    
    /// Description of the error 
    var errorDescription: String? {
        switch self {
        case .url:
            return Strings.url
        case .client(let error):
            return error.localizedDescription
        case .server(let response):
            guard let response = response as? HTTPURLResponse else { return Strings.server}
            return "\(Strings.server): \(Strings.error) \(response.statusCode)"
        case .noData:
            return Strings.noData
        case .decoding(let error):
            guard let error = error else { return Strings.decoding }
            return "\(Strings.decoding): \(error.localizedDescription)"
        case .noResult:
            return Strings.emptyData
        }
    }
    
    var imageName: String {
        switch self {
        case .noResult:
            return "empty"
        default:
            return "warning"
        }
    }
}

extension NetworkError: Equatable {
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.url, .url): return true
        case (.client, .client): return true
        case (.server, .server): return true
        case (.noData, .noData): return true
        case (.decoding, .decoding): return true
        case (.noResult, .noResult): return true
        default: return false
        }
    }
}
