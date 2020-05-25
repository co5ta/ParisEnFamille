//
//  EventsResult.swift
//  ParisNature
//
//  Created by co5ta on 23/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// The type containing the decoded response of events API
struct EventsResult {
    /// Total number of available events
    let total: Int
    /// List of events founded by the request
    let list: [Event]
}

// MARK: - Decodable
extension EventsResult: Decodable {
    /// Relations between properties and json keys
    enum CodingKeys: String, CodingKey {
        case total = "nhits"
        case list = "records"
    }
}
