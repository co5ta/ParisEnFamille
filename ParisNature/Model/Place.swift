//
//  Place.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

protocol Place: MKAnnotation {
    var placeType: PlaceType { get }
    var title: String? { get }
    var address: String { get }
    var coordinate: CLLocationCoordinate2D { get set }
}
