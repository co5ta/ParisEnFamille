//
//  PlaceType.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

/// Gathers informations about the place types
enum PlaceType: String, CaseIterable {
    
    /// Animation place type
    case activity
    case conference = "Animations -> Conférence / Débat"
    case reading = "Animations -> Lecture / Rencontre"
    case games = "Animations -> Loisirs / Jeux"
    case otherAnimation = "Animations -> Autre animation"
    /// Education place type
    case education
    case workshop = "Animations -> Atelier / Cours"
    case practicum = "Animations -> Stage"
    /// Exhibit place type
    case exhibit
    case contemporary = "Expositions -> Art Contemporain"
    case fineArts = "Expositions -> Beaux-Arts"
    case design = "Expositions -> Design / Mode"
    case history = "Expositions -> Histoire / Civilisations"
    case illustration = "Expositions -> Illustration / BD"
    case photography = "Expositions -> Photographie"
    case science = "Expositions -> Sciences / Techniques"
    case streetArt = "Expositions -> Street-art"
    case otherExhibit = "Expositions -> Autre expo"
    /// Visit place type
    case ramble
    case visit
    case park
    case garden
    case promenade
    /// To display all subtypes of a place type
    case all
    
    /// List of parent place types
    static let parents: [PlaceType] = [
        .activity,
        .education,
        .exhibit,
        .ramble
    ]
    
    /// List of chilf place types
    var children: [PlaceType] {
        switch self {
        case .activity:
            return [.all, .conference, .reading, .games, .otherAnimation]
        case .education:
            return [.all, .workshop, .practicum]
        case .exhibit:
            return [.all, .contemporary, .fineArts, .design, .history, .illustration, .photography, .science, .streetArt, .otherExhibit]
        case .ramble:
            return [.visit, .park, .garden, .promenade]
        default:
            return []
        }
    }
    
    /// Name of the associated image
    var imageName: String {
        switch self {
        case .activity: return "event"
        case .education: return "teach"
        case .exhibit: return "museum"
        case .ramble: return "backpacker"
        default: return ""
        }
    }
    
    /// Name of the associates image when selected
    var imageSelectedName: String {
        imageName + "Color"
    }
    
    /// Title of the place type
    var title: String {
        switch self {
        // Animation
        case .activity: return Strings.activity
        case .conference: return Strings.conference
        case .reading: return Strings.reading
        case .games: return Strings.games
        case .otherAnimation: return Strings.otherAnimation
        // Education
        case .education: return Strings.education
        case .workshop: return Strings.workshop
        case .practicum: return Strings.practicum
        // Exhibit
        case .exhibit: return Strings.exhibit
        case .contemporary: return Strings.contemporary
        case .fineArts: return Strings.fineArts
        case .design: return Strings.design
        case .history: return Strings.history
        case .illustration: return Strings.illustration
        case .photography: return Strings.photography
        case .science: return Strings.science
        case .streetArt: return Strings.streetArt
        case .otherExhibit: return Strings.otherExhibit
        // Visit
        case .ramble : return Strings.ramble
        case .visit: return Strings.visit
        case .park: return Strings.park
        case .garden: return Strings.garden
        case .promenade: return Strings.promenade
        // No filter
        case .all: return "All"
        }
    }
}

// MARK: - Endpoints
extension PlaceType {
    
    var dataset: String {
        switch self {
        case .park, .garden, .promenade:
            return "dataset=espaces_verts"
        default:
            return "dataset=que-faire-a-paris-&sort=date_end"
        }
    }
    
    /// URL to search places from a place type
    var apiURL: String? {
        var url = "https://opendata.paris.fr/api/records/1.0/search/?rows=600&" + dataset
        switch self {
        // Animation
        case .activity:
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: [PlaceType.conference.rawValue,
                                             PlaceType.reading.rawValue,
                                             PlaceType.games.rawValue,
                                             PlaceType.otherAnimation.rawValue])
        // Education
        case .education:
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: [PlaceType.workshop.rawValue,
                                             PlaceType.practicum.rawValue])
        // Exhibit
        case .exhibit:
            url += includeCategory("Expositions+")
        
        // Visit
        case .ramble, .visit:
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: PlaceType.visitCategories )
        case .park:
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Parc", "Bois", "Pelouse", "Arboretum", "Ile"])
        case .garden:
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Jardin", "Jardin d'immeubles", "Archipel"])
        case .promenade:
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Esplanade", "Promenade"])
        default:
            return nil
        }
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}

// MARK: - API Categories
extension PlaceType {
    
    /// The category to include in the search
    private func includeCategory(_ categorie: String) -> String {
        return "&refine.category=\(categorie)"
    }
    
    /// The categories to exclude from the search
    private func excludeCategories(from list: [String], notIn categoriesToKeep: [String]) -> String {
        let keyword = (list == PlaceType.eventCategories) ? "category" : "categorie"
        let categories = list.map { categoriesToKeep.contains($0) == false ? "&exclude.\(keyword)=\($0)" : ""}.joined()
        return categories
    }
    
    static var eventCategories: [String] {
        PlaceType.allCases.map { $0.rawValue } + visitCategories + offTopicCategories
    }
    
    static let visitCategories = [
        "Animations -> Balade",
        "Animations -> Visite guidée"
    ]
    
    static let offTopicCategories = [
        "Concerts+",
        "Événements+",
        "Spectacles+"
    ]
    
    /// List of green space categories
    static let greenspaceCategories = [
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
