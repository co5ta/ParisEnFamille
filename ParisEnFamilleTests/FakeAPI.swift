//
//  FakeData.swift
//  ParisEnFamilleTests
//
//  Created by co5ta on 06/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// A class to simulate the behavior of the API
class FakeAPI {
    
    /// Fake url
    static let url = URL(string: "fakeapi")!
    /// Bad response type
    static let badResponseType = URLResponse()
    /// Good response
    static let responseCode200 = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    /// Bad response
    static let responseCode500 = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
    /// Bad data
    static let badData = "".data(using: .utf8)!
    
    /// Get data from a test json
    static func getJson(name: String) -> Data {
        let json = Bundle(for: FakeAPI.self).url(forResource: name, withExtension: "json")!
        // swiftlint:disable force_try
        let data = try! Data(contentsOf: json)
        return data
    }
}
