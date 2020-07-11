//
//  FakeData.swift
//  ParisNatureTests
//
//  Created by co5ta on 06/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

class FakeAPI {
    static let url = URL(string: "fakeapi")!
    static let badResponseType = URLResponse()
    static let responseCode200 = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseCode500 = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
    static let badData = "".data(using: .utf8)!
    
    static func getJson(name: String) -> Data {
        guard let json = Bundle(for: FakeAPI.self).url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: json) else { return Data() }
        return data
    }
}
