//
//  PlaceAnnotationView.swift
//  ParisNature
//
//  Created by co5ta on 21/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotationView: MKMarkerAnnotationView {

//    var place: Place { didSet {configure()} }
//    let name = String()
    static let identifer = "PlaceAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "Place"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
