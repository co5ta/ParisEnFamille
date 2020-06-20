//
//  PlaceType.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

///
enum PlaceType: Int, CaseIterable {
    
    // List of placetype
    case park
    case garden
    case other
    case event
    case animations
    
    static let children: [PlaceType: [String]] = [
        .park: ["truc", "mushe", "chose", "machin", "landsval"],
        .garden: ["culbuto", "tartampion", "colonel", "tapion"],
        .other: ["bebeto", "le bandeau", "berizzo", "diego", "armando", "bogard"],
        .event: ["amidele", "champion", "lopez", "diaz", "tete de brique"]
    ]
    
    static let parents: [PlaceType] = [
        .park, .garden, .other, .event
    ]
    
    /// Name of the associated image
    var imageName: String {
        switch self {
        case .park: return "park"
        case .garden: return "garden"
        case .other: return "other"
        case .event: return "event"
        default: return ""
        }
    }
    
    /// Suffix for an selected image
    private var imageSelectedSuffix: String { "Color" }
    
    /// Name of the associates image when selected
    var imageSelectedName: String { imageName + imageSelectedSuffix }
    
    /// Title of the place type
    var title: String {
        switch self {
        case .park: return "Parks"
        case .garden: return "Gardens"
        case .other: return "Walks"
        case .event: return "Events"
        case .animations: return "Animations"
        }
    }
    
    /// Returns true when the search is limited around the user location
    var limitedAround: Bool {
        switch self {
        case .garden:
            return true
        default:
            return false
        }
    }
    
    /// URL to search places from a place type
    var apiURL: String? {
        var url = "https://opendata.paris.fr/api/records/1.0/search/?"
        switch self {
        case .park:
            url += "dataset=espaces_verts"
            url += filterCategories(notIn: ["Parc", "Bois", "Pelouse", "Arboretum", "Ile"])
        case .garden:
            url += "dataset=espaces_verts"
            url += filterCategories(notIn: ["Jardin", "Jardin d'immeubles", "Jardiniere", "Square", "Archipel"])
        case .other:
            url += "dataset=espaces_verts"
            url += filterCategories(notIn: ["Archipel", "Esplanade", "Ile", "Promenade"])
        case .event:
            url += "dataset=que-faire-a-paris-&sort=date_start&refine.tags=Végétalisons+Paris"
        default:
            break
        }
        url += "&rows=100"
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
    
    private func filterCategories(notIn categoriesToKeep: [String]) -> String {
        var filter = ""
        for categorie in PlaceType.categories {
            if categoriesToKeep.contains(categorie) == false {
                filter += "&exclude.categorie=\(categorie)"
            }
        }
        return filter
    }
    
    static let categories = [
        "Arboretum",
        "Archipel",
        "Bois",
        "Cimetière",
        "Decoration",
        "Espace Vert",
        "Esplanade",
        "Ile",
        "Jardin",
        "Jardin d'immeubles",
        "Jardin partage",
        "Jardinet",
        "Jardiniere",
        "Mail",
        "Murs vegetalises",
        "Parc",
        "Pelouse",
        "Plate-bande",
        "Promenade",
        "Square",
        "Talus",
        "Terrain de boules",
        "Terre-plein"
    ]
}
