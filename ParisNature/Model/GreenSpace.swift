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
    let surface: Int?
    /// Horticultural surface in m2
    let horticulture: Int?
    /// Indicates if the greenspace has a fence
    let fence: String
    /// Indicates if the greespance is open 24H a day
    let open24h: String
    
    /// Initializes from json data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .nomEv)
        let streetNumber = try fields.decode(Int.self, forKey: .adresseNumero)
        let streetType = try fields.decode(String.self, forKey: .adresseTypevoie)
        let streetName = try fields.decode(String.self, forKey: .adresseLibellevoie)
        let zipCode = try fields.decode(String.self, forKey: .adresseCodepostal)
        let city = String(zipCode.prefix(2)) == "75" ? "Paris": ""
        address = "\(streetNumber) \(streetType) \(streetName) \n\(zipCode) \(city) "
        geom = try fields.decode(Geom.self, forKey: .geom)
        if let location = geom.location {
            coordinate = location
        }
        surface = try fields.decodeIfPresent(Int.self, forKey: .surfaceTotaleReelle)
        horticulture = try fields.decodeIfPresent(Int.self, forKey: .surfaceHorticole)
        
        let cloture = try fields.decodeIfPresent(String.self, forKey: .presenceCloture)
        if let cloture = cloture {
            fence = cloture == "Oui" ? "Yes" : "No"
        } else {
            fence = "Not disclosed"
        }
        
        let ouvertFerme = try fields.decodeIfPresent(String.self, forKey: .ouvertFerme)
        if let ouvertFerme = ouvertFerme {
            open24h = ouvertFerme == "Oui" ? "Yes" : "No"
        } else {
            open24h = "Not disclosed"
        }
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
        case presenceCloture
        case ouvertFerme
        case geom
        case surfaceTotaleReelle
        case surfaceHorticole
    }
}

extension GreenSpace {
    static func getFormattedSurface(surface: Int?) -> String {
        guard let surface = surface else { return "Not available" }
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        let surfaceFormatted = formatter.string(fromDistance: formatter.distance(from: "\(surface) m"))
        return "\(surfaceFormatted)²"
    }
}
