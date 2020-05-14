//
//  NetworkService.swift
//  ParisNature
//
//  Created by co5ta on 09/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

struct NetworkService {

    /// Session of the network
    let session: URLSession
    /// Shared instance of NetworkService
    static let shared = NetworkService()
    
    /// Initializes the instance
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

// MARK: - Requests
extension NetworkService {
    
    /// Gets green areas
    func getGreenAreas(area: [String], completionHandler: @escaping (Result<GreenAreasResult, NetworkError>) -> Void) {
        let stringURL = "https://opendata.paris.fr/api/records/1.0/search/?dataset=espaces_verts&refine.type_ev=Promenades+ouvertes&rows=50&geofilter.distance=\(area.joined(separator: ","))"
        print(stringURL)
        guard let url = URL(string: stringURL) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                /// Checks error
                if let error = error {
                    completionHandler( .failure(.client(error)) )
                    return
                }
                /// Checks response
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode)
                    else {
                    completionHandler( .failure(.server(response)) )
                    return
                }
                /// Checks data
                guard let data = data else {
                    completionHandler( .failure(.emptyData) )
                    return
                }
                /// Converts data
                print(data)
                do {
                    let decodedData = try JSONDecoder().decode(GreenAreasResult.self, from: data)
                    completionHandler( .success(decodedData) )
                } catch let error {
                    completionHandler( .failure(.decoding(error)) )
                }
            }
        }
        task.resume()
    }
}
