//
//  PlaceType.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

///
enum PlaceType: String, CaseIterable {
    
    /// Animation place type
    case activity, conference, reading, games, otherAnimation
    /// Education place type
    case education, workshop, practicum
    /// Exhibit place type
    case exhibit, contemporary, fineArts, design, history, illustration, photography, science, streetArt, otherExhibit
    /// Ramble place type
    case ramble, visit, park, garden, promenade
    
    /// List of parent place types
    static let parents: [PlaceType] = [
        .education,
        .exhibit,
        .ramble,
        .activity
    ]
    
    /// List of chilf place types
    static let children: [PlaceType: [PlaceType]] = [
        .activity: [.conference, .reading, .games, .otherAnimation],
        .education: [workshop, practicum],
        .exhibit: [.contemporary, .fineArts, .design, .history, .illustration, .photography, .science, .streetArt, .otherExhibit],
        .ramble: [.visit, .park, .garden, promenade]
    ]
    
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
    var imageSelectedName: String { "\(imageName)Color"}
    
    /// Title of the place type
    var title: String {
        switch self {
        // Animation
        case .activity: return "Activity"
        case .conference: return "Conference"
        case .reading: return "Reading"
        case .games: return "Games"
        case .otherAnimation: return "Others"
        // Education
        case .education: return "Learning"
        case .workshop: return "Workshop"
        case .practicum: return "Practicum"
        // Exhibit
        case .exhibit: return "Exhibit"
        case .contemporary: return "Contemporary"
        case .fineArts: return "Fine Arts"
        case .design: return "Design"
        case .history: return "History"
        case .illustration: return "Illustration"
        case .photography: return "Photography"
        case .science: return "Science"
        case .streetArt: return "Street-art"
        case .otherExhibit: return "Others"
        // Ramble
        case .ramble: return "Ramble"
        case .visit: return "Visit"
        case .park: return "Park"
        case .garden: return "Garden"
        case .promenade: return "Promenade"
        }
    }
    
    /// URL to search places from a place type
    var apiURL: String? {
        var url = "https://opendata.paris.fr/api/records/1.0/search/"
        let greenspaceDataSet = "?dataset=espaces_verts"
        let eventDataSet = "?dataset=que-faire-a-paris-&sort=date_end"
        
        switch self {
        // Animation
        case .activity:
            url += eventDataSet
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: ["Animations -> Conférence / Débat",
                                             "Animations -> Lecture / Rencontre",
                                             "Animations -> Loisirs / Jeux",
                                             "Animations -> Autre animation"])
        case .conference:
            url += eventDataSet + includeCategory("Animations -> Conférence / Débat")
        case .reading:
            url += eventDataSet + includeCategory("Animations -> Lecture / Rencontre")
        case .games:
            url += eventDataSet + includeCategory("Animations -> Loisirs / Jeux")
        case .otherAnimation:
            url += eventDataSet + includeCategory("Animations -> Autre animation")
        
        // Education
        case .education:
            url += eventDataSet
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: ["Animations -> Atelier / Cours",
                                             "Animations -> Stage"])
        case .workshop:
            url += eventDataSet + includeCategory("Animations -> Atelier / Cours")
        case .practicum:
            url += eventDataSet + includeCategory("Animations -> Stage")
            
        // Exhibit
        case .exhibit:
            url += eventDataSet + includeCategory("Expositions+")
        case .contemporary:
            url += eventDataSet + includeCategory("Expositions -> Design / Mode")
        case .fineArts:
            url += eventDataSet + includeCategory("Expositions -> Beaux-Arts")
        case .design:
            url += eventDataSet + includeCategory("Expositions -> Design / Mode")
        case .history:
            url += eventDataSet + includeCategory("Expositions -> Histoire / Civilisations")
        case .illustration:
            url += eventDataSet + includeCategory("Expositions -> Illustration / BD")
        case .otherExhibit:
            url += eventDataSet + includeCategory("Expositions -> Autre expo")
        
        // Ramble
        case .ramble, .visit:
            url += eventDataSet
            url += excludeCategories(from: PlaceType.eventCategories,
                                     notIn: ["Animations -> Balade",
                                             "Animations -> Visite guidée"])
        case .park:
            url += greenspaceDataSet
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Parc", "Bois", "Pelouse", "Arboretum", "Ile"])
        case .garden:
            url += greenspaceDataSet
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Jardin", "Jardin d'immeubles", "Archipel"])
        case .promenade:
            url += greenspaceDataSet
            url += excludeCategories(from: PlaceType.greenspaceCategories,
                                     notIn: ["Esplanade", "Promenade"])
            
        // Nil value
        default: break
        }
        
        url += "&rows=200"
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}

// MARK: - API Categories
extension PlaceType {
    
    private func includeCategory(_ categorie: String) -> String {
        return "&refine.category=\(categorie)"
    }
    
    private func excludeCategories(from list: [String], notIn categoriesToKeep: [String]) -> String {
        let keyword = (list == PlaceType.eventCategories) ? "category" : "categorie"
        var categories = ""
        for categorie in list {
            if categoriesToKeep.contains(categorie) == false {
                categories += "&exclude.\(keyword)=\(categorie)"
            }
        }
//        let test = list.map { !categoriesToKeep.contains($0) ? "&exclude.categorie=\($0)" : ""}.joined()
        return categories
    }
    
    static let eventCategories = [
        // Animations
        "Animations -> Atelier / Cours",
        "Animations -> Autre animation",
        "Animations -> Balade",
        "Animations -> Conférence / Débat",
        "Animations -> Lecture / Rencontre",
        "Animations -> Loisirs / Jeux",
        "Animations -> Stage",
        "Animations -> Visite guidée",
        // Exhibit
        "Expositions -> Art Contemporain",
        "Expositions -> Autre expo",
        "Expositions -> Beaux-Arts",
        "Expositions -> Design / Mode",
        "Expositions -> Histoire / Civilisations",
        "Expositions -> Illustration / BD",
        "Expositions -> Photographie",
        "Expositions -> Sciences / Techniques",
        "Expositions -> Street-art",
        // Off topic
        "Concerts+",
        "Événements+",
        "Spectacles+"
    ]
    
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
