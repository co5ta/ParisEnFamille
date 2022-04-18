//
//  NetworkService.swift
//  ParisEnFamille
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// Service which fetchs the data
class NetworkService {

    /// Network session
    private let session: URLSession
    /// Default instance
    static let shared = NetworkService()
    /// Session task
    private var task: URLSessionDataTask?
    /// JSON Decoder
    private let decoder: JSONDecoder
    
    /// Initializes the instance
    init(session: URLSession = URLSession.shared) {
        self.session = session
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
}

extension NetworkService {
    enum Endpoints {
        static let events = "https://opendata.paris.fr/api/records/1.0/search/?rows=50&dataset=que-faire-a-paris-&sort=date_end"
    }
}

// MARK: - Requests
extension NetworkService {
    
    func fetchItems<T: Decodable>(of type: T.Type) async throws -> T {
        guard let url = URL(string: Endpoints.events) else { throw NetworkError.url }
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode)
        else { throw NetworkError.server(response) }
        return try decoder.decode(type, from: data)
    }
}
