//
//  PlaceAnnotationView.swift
//  ParisEnFamille
//
//  Created by co5ta on 21/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import MapKit

/// Custom annotation view
class PlaceAnnotationView: MKMarkerAnnotationView {
    
    /// Annotation identifier
    static let identifer = "PlaceAnnotation"
    
//    override var annotation: MKAnnotation? { didSet { self.displayPriority = .required } }
    
    /// Initializes from code
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "Place"
    }

    /// Initializes form storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
