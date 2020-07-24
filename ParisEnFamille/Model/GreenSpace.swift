//
//  GreenSpace.swift
//  ParisEnFamille
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// The type containing the decoded response of green spaces API
struct GreenSpacesResult: Decodable {
    /// List of green area founded by the request
    let records: [GreenSpace]
}

/// The class representing a green area
class GreenSpace: NSObject, Place {
    
    /// Name
    let title: String?
    /// Subtitle
    let subheading: String
    /// geometry
    let geom: Geom
    /// Address
    let address: String
    /// Department
    let department: String
    /// GPS coordinate
    var coordinate: CLLocationCoordinate2D
    /// Surface in m2
    let surface: Int?
    /// Horticultural surface in m2
    let horticulture: Int?
    /// Indicates if the greenspace has a fence
    let fence: String
    /// Indicates if the greespance is open 24H a day
    let open24h: String
    /// Opening year
    let openingYear: String
    /// Place type
    let placeType: PlaceType? = nil
    /// Always true as the greenspace doesn't expire in time
    let isInTimeInterval = true
    
    /// Initializes from json data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        title = try fields.decode(String.self, forKey: .nomEv).localizedCapitalized
        let streetNumber = try fields.decode(Int.self, forKey: .adresseNumero)
        let streetType = try fields.decode(String.self, forKey: .adresseTypevoie).localizedLowercase
        let streetName = try fields.decode(String.self, forKey: .adresseLibellevoie).localizedCapitalized
        let zipCode = try fields.decode(String.self, forKey: .adresseCodepostal)
        department = String(zipCode.prefix(2))
        let city = department == "75" ? "Paris": ""
        address = "\(streetNumber) \(streetType) \(streetName) \n\(zipCode) \(city)"
        geom = try fields.decode(Geom.self, forKey: .geom)
        coordinate = geom.location ?? CLLocationCoordinate2D()
        surface = try fields.decodeIfPresent(Int.self, forKey: .surfaceTotaleReelle)
        horticulture = try fields.decodeIfPresent(Int.self, forKey: .surfaceHorticole)
        let presenceCloture = try fields.decodeIfPresent(String.self, forKey: .presenceCloture)
        fence = presenceCloture == nil ? Strings.undisclosed : presenceCloture == "Oui" ? Strings.yes : Strings.not
        let ouvertFerme = try fields.decodeIfPresent(String.self, forKey: .ouvertFerme)
        open24h = ouvertFerme == nil ? Strings.undisclosed : ouvertFerme == "Oui" ? Strings.yes : Strings.not
        openingYear = try fields.decodeIfPresent(String.self, forKey: .anneeOuverture) ?? Strings.undisclosed
        subheading = "\(streetNumber) \(streetType) \(streetName)"
    }
    
    /// Gives the surface of a green space in m²
    static func getFormattedSurface(surface: Int?) -> String {
        guard let surface = surface else { return Strings.unavailable }
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        return formatter.string(fromDistance: formatter.distance(from: "\(surface) m²"))
    }
    
    /// Keys to decode from the json
    enum CodingKeys: String, CodingKey {
        // Keys used in the json
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
        case anneeOuverture
    }
}
