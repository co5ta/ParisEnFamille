//
//  EventItem.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 26/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

struct EventItems: Decodable {
    let records: [EventItem]
}

struct EventItem: AnyItem {
    let title: String
    let subtitle: String
    let description: String
    let address: String
    let coverUrl: String
    let tags: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .title)
        subtitle = try fields.decodeIfPresent(String.self, forKey: .leadText) ?? ""
        description = try fields.decodeIfPresent(String.self, forKey: .description) ?? ""
        coverUrl = try fields.decode(String.self, forKey: .coverUrl)
        tags = try fields.decodeIfPresent(String.self, forKey: .tags) ?? ""
        
        var addressName = try fields.decodeIfPresent(String.self, forKey: .addressName)
        addressName = addressName == nil ? addressName : addressName! + "\n"
        let addressStreet = try fields.decodeIfPresent(String.self, forKey: .addressStreet) ?? ""
        let addressZipcode = try fields.decodeIfPresent(String.self, forKey: .addressZipcode) ?? ""
        let addressCity = try fields.decodeIfPresent(String.self, forKey: .addressCity)
        address = "\(addressName ?? "")\(addressStreet) \n\(addressZipcode) \(addressCity ?? "")"
    }
}

extension EventItem {
    /// Keys to decode from the json
    enum CodingKeys: String, CodingKey {
        // Keys used in the json
        case fields
        case title
        case leadText
        case description
        case coverUrl
        case tags
        
        case addressName
        case addressStreet
        case addressZipcode
        case addressCity
        case latLon
        case dateStart
        case dateEnd
        case dateDescription
        case accessType
        case priceType
        case priceDetail
        case contactName
        case accessLink
        case contactUrl
        case contactPhone
        case contactMail
    }
}