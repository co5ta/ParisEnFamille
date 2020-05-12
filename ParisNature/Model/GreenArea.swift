//
//  GreenArea.swift
//  ParisNature
//
//  Created by co5ta on 10/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// The type representing a green area
struct GreenArea {
    /// Name
    let name: String
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
    /// Address
    var address: String { "\(streetNumber) \(streetType) \(streetName) \(areaCode)" }
    /// List of all green areas
    static var list: [GreenArea] = []
}

// MARK: - Decodable
extension GreenArea: Decodable {
    
    /// Initializes from json data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fields = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .fields)
        name = try fields.decode(String.self, forKey: .name)
        category = try fields.decode(String.self, forKey: .category)
        streetNumber = try fields.decode(Int.self, forKey: .streetNumber)
        streetType = try fields.decode(String.self, forKey: .streetType)
        streetName = try fields.decode(String.self, forKey: .streetName)
        areaCode = try fields.decode(String.self, forKey: .areaCode)
        hasFence = try (fields.decodeIfPresent(String.self, forKey: .hasFence) == "Oui") ? true : false
        isOpen24Hours = try (fields.decodeIfPresent(String.self, forKey: .isOpen24Hours) == "Oui") ? true : false
    }
    
    /// Relations between properties and json keys
    enum CodingKeys: String, CodingKey {
        case fields
        case name = "nom_ev"
        case category = "categorie"
        case streetNumber = "adresse_numero"
        case streetType = "adresse_typevoie"
        case streetName = "adresse_libellevoie"
        case areaCode = "adresse_codepostal"
        case hasFence = "presence_cloture"
        case isOpen24Hours = "ouvert_ferme"
    }
}
