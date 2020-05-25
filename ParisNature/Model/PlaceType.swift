//
//  PlaceType.swift
//  ParisNature
//
//  Created by co5ta on 18/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

enum PlaceType: Int, CaseIterable {
    case greenery
    case event
    case market
    
    private var imageSelectedSuffix: String { "Color" }
    
    var imageName: String {
        switch self {
        case .greenery: return "city"
        case .event: return "event"
        case .market: return "market"
        }
    }
    
    var imageSelectedName: String {
        imageName + imageSelectedSuffix
    }
    
    var title: String {
        switch self {
        case .greenery: return "Greenery"
        case .event: return "Events"
        case .market: return "Markets"
        }
    }
    
    var apiURL: String? {
        var url = "https://opendata.paris.fr/api/records/1.0/search/?"
        switch self {
        case .greenery:
            url += "dataset=espaces_verts&refine.type_ev=Promenades+ouvertes&rows=25"
        case .event:
            url += "dataset=que-faire-a-paris-&sort=date_start&refine.tags=Végétalisons+Paris"
        case .market: return ""
        }
        return url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    }
}
