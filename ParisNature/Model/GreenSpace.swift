//
//  GreenSpace.swift
//  ParisNature
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// The type representing a green area
class GreenSpace: NSObject, Place {
    
    /// Type of place
    let placeType = PlaceType.park
    /// Name
    let title: String?
    /// Category
    let category: String
    /// Street number
    let streetNumber: Int
    /// Street type
    let streetType: String
    /// Street name
    let streetName: String
    /// Area code
    let areaCode: String
    /// True if the green area has fence
    let hasFence: Bool?
    /// True if the green area is open 24 hours a day
    let isOpen24Hours: Bool?
    /// geometry
    let geom: Geom
    /// GPS coordinate
    var coordinate = CLLocationCoordinate2D()
    /// Address
    var address: String { "\(streetNumber) \(streetType) \(streetName) \(areaCode)" }
    
    /// Initializes from json data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .nomEv)
        category = try fields.decode(String.self, forKey: .categorie)
        streetNumber = try fields.decode(Int.self, forKey: .adresseNumero)
        streetType = try fields.decode(String.self, forKey: .adresseTypevoie)
        streetName = try fields.decode(String.self, forKey: .adresseLibellevoie)
        areaCode = try fields.decode(String.self, forKey: .adresseCodepostal)
        hasFence = try (fields.decodeIfPresent(String.self, forKey: .presenseCloture) == "Oui") ? true : false
        isOpen24Hours = try (fields.decodeIfPresent(String.self, forKey: .ouvertFerme) == "Oui") ? true : false
        geom = try fields.decode(Geom.self, forKey: .geom)
        if let location = geom.location { coordinate = location }
    }
}

// MARK: - CodingKey
extension GreenSpace {
    /// Relations between properties and json keys
    enum CodingKeys: String, CodingKey {
        case fields
        case nomEv
        case categorie
        case adresseNumero
        case adresseTypevoie
        case adresseLibellevoie
        case adresseCodepostal
        case presenseCloture
        case ouvertFerme
        case geom
    }
}
