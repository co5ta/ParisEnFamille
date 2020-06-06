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
//
    let dateStart: Date
//
    let dateEnd: Date
//
//    let dateDescription: String
//
    let leadText: String
    ///
    let contactName: String?
    ///
    let contactUrl: String?
    ///
    let contactPhone: String?
    ///
    let contactMail: String?
//
//    let imageURL:  String
//
//    let format: String
//
    var access = [String]()
    
    ///
    let address: String
    ///
    var coordinate = CLLocationCoordinate2D()
    ///
    var distance: CLLocationDistance?
    ///
    let accessList = ["gratuit": "Free", "payant": "Payable", "reservation": "on reservation"]
    
    required init(from decoder: Decoder) throws {
        placeType = .event
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .title)
        let addressName = try fields.decode(String.self, forKey: .addressName)
        let addressStreet = try fields.decode(String.self, forKey: .addressStreet)
        let addressZipcode = try fields.decode(String.self, forKey: .addressZipcode)
        let addressCity = try fields.decodeIfPresent(String.self, forKey: .addressCity)
        address = "\(addressName) \n\(addressStreet) \(addressZipcode) \(addressCity ?? "")"
        if let latLon = try fields.decodeIfPresent([Double].self, forKey: .latLon), addressCity != nil {
            coordinate = CLLocationCoordinate2D(latitude: latLon[0], longitude: latLon[1])
        }
        dateStart = try fields.decode(Date.self, forKey: .dateStart)
        dateEnd = try fields.decode(Date.self, forKey: .dateEnd)
        leadText = try fields.decode(String.self, forKey: .leadText)
        let accessType = try fields.decode(String.self, forKey: .accessType)
        let priceType = try fields.decode(String.self, forKey: .priceType)
        if let priceText = accessList[priceType] {
            access.append(priceText)
        }
        if let accessText = accessList[accessType] {
            access.append(accessText)
        }
        contactName = try fields.decodeIfPresent(String.self, forKey: .contactName)
        contactUrl = try fields.decodeIfPresent(String.self, forKey: .contactUrl)
        contactMail = try fields.decodeIfPresent(String.self, forKey: .contactMail)
        contactPhone = try fields.decodeIfPresent(String.self, forKey: .contactPhone)
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
        case dateStart
        case dateEnd
        case leadText
        case accessType
        case priceType
        
        case contactName
        case contactUrl 
        case contactPhone
        case contactMail
        
        case cover
        case imageURL
        case format
        case dateDescription
        
    }
}
