//
//  Event.swift
//  ParisNature
//
//  Created by co5ta on 23/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// The type containing the decoded response of events API
struct EventsResult: Decodable {
    let records: [Event]
}

/// The class representing an event
class Event: NSObject, Place {
    
    /// Title of the event
    let title: String?
    /// Category of the event
    let subheading: String
    /// First date of the event
    let dateStart: Date
    /// Last date of the event
    let dateEnd: Date
    /// Dates of the event
    let dateDescription: String
    /// Short description of the event
    let leadText: String
    /// Longer description of the event
    let descriptionText: String
    /// Name of the contact
    let contactName: String?
    /// URL of the reservation
    let accessLink: String?
    /// URL of the website
    let contactUrl: String?
    /// Phone number
    let contactPhone: String?
    /// Mail address
    let contactMail: String?
    /// Array of available access for the place
    var access = [String]()
    /// Detail about price
    let priceDetail: String?
    /// Address
    let address: String
    /// Department
    let department: String
    /// Coordinate of the place
    var coordinate = CLLocationCoordinate2D()
    /// Distance between the event and the user location
    var distance: CLLocationDistance?
    /// List of access type
    let accessList = ["gratuit": Strings.free, "payant": Strings.payable, "reservation": Strings.onReservation]
    
    /// Creates a new instance by decoding from the json
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .title)
        let addressName = try fields.decodeIfPresent(String.self, forKey: .addressName)
        let addressStreet = try fields.decode(String.self, forKey: .addressStreet)
        let addressZipcode = try fields.decode(String.self, forKey: .addressZipcode)
        department = String(addressZipcode.prefix(2))
        let addressCity = try fields.decodeIfPresent(String.self, forKey: .addressCity)
        address = "\(addressName ?? "") \n\(addressStreet) \n\(addressZipcode) \(addressCity ?? "")"
        if let latLon = try fields.decodeIfPresent([Double].self, forKey: .latLon), addressCity != nil {
            coordinate = CLLocationCoordinate2D(latitude: latLon[0], longitude: latLon[1])
        }
        dateStart = try fields.decode(Date.self, forKey: .dateStart)
        dateEnd = try fields.decode(Date.self, forKey: .dateEnd)
        dateDescription = try fields.decode(String.self, forKey: .dateDescription)
        leadText = try fields.decode(String.self, forKey: .leadText)
        descriptionText = try fields.decode(String.self, forKey: .description)
        let accessType = try fields.decode(String.self, forKey: .accessType)
        let priceType = try fields.decode(String.self, forKey: .priceType)
        if let priceText = accessList[priceType] { access.append(priceText) }
        if let accessText = accessList[accessType] { access.append(accessText) }
        priceDetail = try fields.decodeIfPresent(String.self, forKey: .priceDetail)
        contactName = try fields.decodeIfPresent(String.self, forKey: .contactName)
        accessLink = try fields.decodeIfPresent(String.self, forKey: .accessLink)
        contactUrl = try fields.decodeIfPresent(String.self, forKey: .contactUrl)
        contactMail = try fields.decodeIfPresent(String.self, forKey: .contactMail)
        contactPhone = try fields.decodeIfPresent(String.self, forKey: .contactPhone)?.replacingOccurrences(of: " ", with: "")
        subheading = addressStreet
    }
    
    /// Keys to decode from the json
    enum CodingKeys: String, CodingKey {
        // Keys used in the json
        case fields
        case title
        case category
        case addressName
        case addressStreet
        case addressZipcode
        case addressCity
        case latLon
        case dateStart
        case dateEnd
        case dateDescription
        case leadText
        case description
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
