//
//  Geom.swift
//  ParisNature
//
//  Created by co5ta on 28/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

struct Geom: Decodable {
    let type: GeomType?
    let shapes: [MKPolygon]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let geomType = try container.decode(String.self, forKey: .type)
        type = GeomType(rawValue: geomType)
        
        switch self.type {
        case .polygon:
            let coordinates = try container.decode([[[Double]]].self, forKey: .coordinates)
            shapes = Geom.getPolygon(with: coordinates)
        case .multiPolygon:
            let coordinates = try container.decode([[[[Double]]]].self, forKey: .coordinates)
            shapes = coordinates.map { Geom.getPolygon(with: $0) }.reduce([], +)
        case .none:
            shapes = nil
        }
    }
    
    static func getPolygon(with geomCoordinates: [[[Double]]]) -> [MKPolygon] {
        let points = geomCoordinates.map { $0.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) } }
        let polygons = points.map { MKPolygon(coordinates: $0, count: $0.count) }
        return polygons
    }
}

extension Geom {
    enum CodingKeys: CodingKey {
        case type
        case coordinates
    }
}

extension Geom {
    enum GeomType: String, CaseIterable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }
}
