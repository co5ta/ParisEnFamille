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
    
    /// Initializes the instance
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

// MARK: - Requests
extension NetworkService {
    
    /// Requests the places to the API
    func getPlaces<T>(placeType: PlaceType, dataType: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) where T: Decodable {
        guard let url = getURL(for: placeType) else {
            completionHandler(.failure(NetworkError.url))
            return
        }
//        print(url)
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                let result = self.handleResult(data, response, error, T.self)
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let data):
                    completionHandler(.success(data))
                }
            }
        }
        task?.resume()
    }
    
    /// Converts the URL from String type to URL type
    private func getURL(for placeType: PlaceType) -> URL? {
        guard let stringURL = placeType.apiURL,
            let url = URL(string: stringURL)
            else { return nil }
        return url
    }
    
    /// Handles the result of the request
    private func handleResult<T>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ dataType: T.Type
    ) -> Result<T, NetworkError> where T: Decodable {
        /// Checks error
        if let error = error { return .failure(.client(error)) }
        /// Checks response
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
            else { return .failure(.server(response)) }
        /// Checks data
        guard let data = data else { return .failure(.noData)}
        /// Converts data
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(dataType, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(.decoding(error))
        }
    }
}
