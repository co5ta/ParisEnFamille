//
//  GreenSpacesResult.swift
//  ParisNature
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// The type containing the decoded response of green spaces API
struct GreenSpacesResult {
    /// Total number of available green areas
    let total: Int
    /// List of green area founded by the request
    let list: [GreenSpace]
}

// MARK: - Decodable
extension GreenSpacesResult: Decodable {
    /// Relations between properties and json keys
    enum CodingKeys: String, CodingKey {
        case total = "nhits"
        case list = "records"
    }
}
