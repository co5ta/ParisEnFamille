//
//  NetworkService.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

class NetworkService {

    /// Session of the network
    private let session: URLSession
    /// Shared instance of NetworkService
    static let shared = NetworkService()
    private var task: URLSessionDataTask?
    
    /// Initializes the instance
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

// MARK: - Requests
extension NetworkService {
    
    func handleResult<T>(_ data: Data?,
                         _ response: URLResponse?,
                         _ error: Error?,
                         _ dataType: T.Type
    ) -> Result<T, NetworkError> where T: Decodable {
        /// Checks error
        if let error = error {
            return .failure(.client(error))
        }
        /// Checks response
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
            else {
            return .failure(.server(response))
        }
        /// Checks data
        guard let data = data else {
            return .failure(.emptyData)
        }
        /// Converts data
        do {
            let decodedData = try JSONDecoder().decode(dataType, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(.decoding(error))
        }
    }
    
    /// Gets green areas
    func getPlaces<T>(placeType: PlaceType,
                      dataType: T.Type,
                      area: [String],
                      completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) where T: Decodable {
        let stringURL = placeType.apiURL + "&geofilter.distance=\(area.joined(separator: ","))"
        print(stringURL)
        guard let url = URL(string: stringURL) else { return }
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
}
