//
//  Place.swift
//  ParisEnFamille
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// Defines the requirement of a place object
protocol Place: MKAnnotation, Decodable {
    
    /// The title of the place
    var title: String? { get }
    /// The address of the place
    var address: String { get }
    /// Department of the place
    var department: String { get }
    /// The  geographic coordinates
    var coordinate: CLLocationCoordinate2D { get }
    /// Subheading of the place
    var subheading: String { get }
    /// Place type
    var placeType: PlaceType? { get }
    /// Returns true if the place is not too far in time to be display
    var isInTimeInterval: Bool { get }
}
