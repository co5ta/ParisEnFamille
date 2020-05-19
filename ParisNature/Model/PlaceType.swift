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
    case animal
    case market
    
    var imageName: String {
        switch self {
        case .greenery: return "city"
        case .event: return "event2"
        case .animal: return "footprint2"
        case .market: return "market2"
        }
    }
    
    var title: String {
        switch self {
        case .greenery: return "Greenery"
        case .event: return "Events"
        case .animal: return "Animals"
        case .market: return "Markets"
        }
    }
}
