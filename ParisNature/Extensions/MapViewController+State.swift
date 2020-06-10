//
//  MapViewController+State.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

extension MapViewController {
    
    /// The available states of the view controller
    enum State {
        // List of states
        case neutral
        case loading
        case placesList(error: NetworkError? = nil)
        case placeDetail(place: Place?)
    }
}
