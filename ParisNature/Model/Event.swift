//
//  Event.swift
//  ParisNature
//
//  Created by co5ta on 23/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

class Event: NSObject, Place {
    
    ///
    let placeType: PlaceType?
    ///
    let title: String?
    ///
    let addressName: String
    ///
    let addressStreet: String
    ///
    let addressZipcode: String
    ///
    let addressCity: String?
    
//    let blind: Bool
//
//    let pmr: Bool
//
//    let deaf: Bool
//
//    let dateStart: String
//
//    let dateEnd: String
//
//    let dateDescription: String
//
//    let detail: String
//
//    let leadText: String
//
//    let detailText: String
//
//    let contactName: String
//
//    let contactPhone: String
//
//    let contactMail: String
//
//    let imageURL:  String
//
//    let format: String
//
//    let accessType: String
//
//    let free: Bool
//
//    let priceDetail: String
    
    ///
    var address: String { "\(addressName) \n\(addressStreet) \(addressZipcode) \(addressCity ?? "")" }
    ///
    var coordinate = CLLocationCoordinate2D()
    ///
    var distance: CLLocationDistance?
    
    required init(from decoder: Decoder) throws {
        placeType = .event
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .title)
        addressName = try fields.decode(String.self, forKey: .addressName)
        addressStreet = try fields.decode(String.self, forKey: .addressStreet)
        addressZipcode = try fields.decode(String.self, forKey: .addressZipcode)
        addressCity = try fields.decodeIfPresent(String.self, forKey: .addressCity)
        if let latLon = try fields.decodeIfPresent([Double].self, forKey: .latLon), addressCity != nil {
            coordinate = CLLocationCoordinate2D(latitude: latLon[0], longitude: latLon[1])
        }
    }
}

// MARK: - CodingKeys
extension Event {
    enum CodingKeys: String, CodingKey {
        
        case fields
        case title
        case addressName
        case addressStreet
        case addressZipcode
        case addressCity
        case latLon
        
        case blind
        case pmr
        case deaf
        case dateStart
        case dateEnd
        case dateDescription
        case description
        case leadText
        case contactName
        case contactPhone
        case contactMail
        case cover
        case imageURL
        case format
        case accessType
        case paying
        case priceDetail
    }
}
