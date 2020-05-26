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
    
    /// Name of the associated image
    var imageName: String {
        switch self {
        case .park: return "park"
        case .garden: return "garden"
        case .other: return "other"
        case .event: return "event"
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
        case .other: return "Others"
        case .event: return "Events"
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
            url += "dataset=espaces_verts&refine.type_ev=Promenades+ouvertes&refine.type_ev=Bois"
            url += "&refine.categorie=Parc&refine.categorie=Bois"
        case .garden:
            url += "dataset=espaces_verts&refine.type_ev=Promenades+ouvertes"
            url += "&refine.categorie=Jardin+d%27immeubles&refine.categorie=Jardin&refine.categorie=Square"
        case .event:
            url += "dataset=que-faire-a-paris-&sort=date_start&refine.tags=Végétalisons+Paris"
        case .other:
            url += "dataset=espaces_verts&refine.type_ev=Promenades+ouvertes"
            url += "&refine.categorie=Arboretum&refine.categorie=Archipel&refine.categorie=Esplanade&refine.categorie=Ile&refine.categorie=Pelouse&refine.categorie=Terrain+de+boules&refine.categorie=Jardiniere&refine.categorie=Plate-bande"
        }
        url += "&rows=25"
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}
