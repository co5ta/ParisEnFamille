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
    var placeType: PlaceType?
    /// Name
    let title: String?
    /// geometry
    let geom: Geom
    /// Address
    let address: String
    /// GPS coordinate
    var coordinate = CLLocationCoordinate2D()
    /// Distance between the place and the user location
    var distance: CLLocationDistance?
    /// Surface in m2
    let surface: Float?
    
    /// Initializes from json data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .nomEv)
        let streetNumber = try fields.decode(Int.self, forKey: .adresseNumero)
        let streetType = try fields.decode(String.self, forKey: .adresseTypevoie)
        let streetName = try fields.decode(String.self, forKey: .adresseLibellevoie)
        let zipCode = try fields.decode(String.self, forKey: .adresseCodepostal)
        address = "\(streetNumber) \(streetType) \(streetName) \(zipCode)"
        geom = try fields.decode(Geom.self, forKey: .geom)
        if let location = geom.location { coordinate = location }
        surface = try fields.decodeIfPresent(Float.self, forKey: .surfaceTotaleReelle)
    }
}

// MARK: - CodingKey
extension GreenSpace {
    /// Relations between properties and json keys
    enum CodingKeys: String, CodingKey {
        case fields
        case nomEv
        case adresseNumero
        case adresseTypevoie
        case adresseLibellevoie
        case adresseCodepostal
        case presenseCloture
        case ouvertFerme
        case geom
        case surfaceTotaleReelle
    }
}
