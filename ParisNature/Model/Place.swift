//
//  Place.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// Defines the requirement of a place object
protocol Place: MKAnnotation, Decodable {
    
    /// The type of place
    var placeType: PlaceType { get }
    /// The title of the place
    var title: String? { get }
    /// The address of the place
    var address: String { get }
    /// The  geographic coordinates
    var coordinate: CLLocationCoordinate2D { get set }
}
