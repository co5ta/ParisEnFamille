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
    
    /// The title of the place
    var title: String? { get }
    /// The address of the place
    var address: String { get }
    /// The  geographic coordinates
    var coordinate: CLLocationCoordinate2D { get }
    /// The distance between the place and the user location
    var distance: CLLocationDistance? { get set }
    ///
    var subheading: String { get }
    /// Calculates the distance between the place and the user
    func calculateDistance(from location: CLLocation?)
}

extension Place {
    
    func calculateDistance(from location: CLLocation?) {
        guard let location = location else { return }
        let placeLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        distance = location.distance(from: placeLocation)
    }
}
