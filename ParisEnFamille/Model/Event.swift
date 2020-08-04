//
//  Event.swift
//  ParisEnFamille
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
    /// Place type
    let placeType: PlaceType?
    
    /// Creates a new instance by decoding from the json
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .title)
        var addressName = try fields.decodeIfPresent(String.self, forKey: .addressName)
        addressName = addressName == nil ? addressName : addressName! + "\n"
        let addressStreet = try fields.decode(String.self, forKey: .addressStreet)
        let addressZipcode = try fields.decode(String.self, forKey: .addressZipcode)
        department = String(addressZipcode.prefix(2))
        let addressCity = try fields.decodeIfPresent(String.self, forKey: .addressCity)
        address = "\(addressName ?? "")\(addressStreet) \n\(addressZipcode) \(addressCity ?? "")"
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
        if let priceText = Event.accessList[priceType] { access.append(priceText) }
        if let accessText = Event.accessList[accessType] { access.append(accessText) }
        priceDetail = try fields.decodeIfPresent(String.self, forKey: .priceDetail)
        contactName = try fields.decodeIfPresent(String.self, forKey: .contactName)
        accessLink = try fields.decodeIfPresent(String.self, forKey: .accessLink)
        contactUrl = try fields.decodeIfPresent(String.self, forKey: .contactUrl)
        contactMail = try fields.decodeIfPresent(String.self, forKey: .contactMail)
        let phone = try fields.decodeIfPresent(String.self, forKey: .contactPhone)
        contactPhone = phone?.replacingOccurrences(of: " ", with: "")
        let category = try fields.decode(String.self, forKey: .category)
        placeType = PlaceType.init(rawValue: category)
        subheading = Event.getLocalizedDate(dateStart, dateEnd)
    }
    
    /// Return true if the event is not too far in time to be display
    var isInTimeInterval: Bool {
        let now = Date()
        let calendar = Calendar.current
        let startInterval = calendar.dateComponents([.month], from: now, to: dateStart)
        let endInterval = calendar.dateComponents([.month, .minute], from: now, to: dateEnd)
        guard let startMonth = startInterval.month,
            let endMonth = endInterval.month,
            let endMinute = endInterval.minute
            else { return false }
        guard endMinute > 1 && (startMonth < 1 || endMonth < 1) else { return false }
        return true
    }
    
    static func getLocalizedDate(_ dateStart: Date, _ dateEnd: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.locale = Locale(identifier: "fr_FR")
        let start = dateformatter.string(from: dateStart)
        let end = dateformatter.string(from: dateEnd)
        return start != end ? "\(Strings.from) \(start) \(Strings.to) \(end)" : start
    }
    
    /// List of access type
    static let accessList = [
        "gratuit": Strings.free,
        "payant": Strings.payable,
        "reservation": Strings.onReservation
    ]
    
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
