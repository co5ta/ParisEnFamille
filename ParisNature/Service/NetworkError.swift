//
//  NetworkError.swift
//  ParisNature
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
    case decoding(Error)
    case emptyData
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    
    /// Description of the error 
    var errorDescription: String? {
        switch self {
        case .url:
            return "The request URL couldn't be generate"
        case .client(let error):
            return error.localizedDescription
        case .server(let response):
            guard let response = response as? HTTPURLResponse else { return "Bad response"}
            return "Bad response: error \(response.statusCode)"
        case .noData:
            return "The request didn't return any data"
        case .decoding(let error):
            return "The data decoding failed: \(error.localizedDescription)"
        case .emptyData:
            return "No place founded"
        }
    }
    
    var imageName: String {
        switch self {
        case .emptyData:
            return "empty"
        default:
            return "warning"
        }
    }
}
