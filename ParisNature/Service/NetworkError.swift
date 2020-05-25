//
//  NetworkError.swift
//  ParisNature
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case client(Error)
    case server(URLResponse?)
    case emptyData
    case decoding(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .url:
            return "The request URL couldn't be generate"
        case .client(let error):
            return error.localizedDescription
        case .server(let response):
            guard let response = response as? HTTPURLResponse else { return "Bad response"}
            return "Bad response: error \(response.statusCode)"
        case .emptyData:
            return "The request didn't find any result"
        case .decoding(let error):
            return "The data decoding failed: \(error.localizedDescription)"
        }
    }
}
