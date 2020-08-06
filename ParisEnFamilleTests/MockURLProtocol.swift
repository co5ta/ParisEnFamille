//
//  MockURLProtocol.swift
//  ParisEnFamilleTests
//
//  Created by co5ta on 08/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import XCTest

/// Class which simulates a network request
class MockURLProtocol: URLProtocol {
    
    /// Request handler
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data))?
    /// Determines whether the protocol subclass can handle the specified request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    /// Returns a canonical version of the specified request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    /// Starts protocol-specific loading of the request
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    /// Stops protocol-specific loading of the request
    override func stopLoading() {}
}
