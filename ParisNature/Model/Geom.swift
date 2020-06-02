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
    let shapes: MKPolygon?
    let location: CLLocationCoordinate2D?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let geomType = try container.decode(String.self, forKey: .type)
        type = GeomType(rawValue: geomType)
        
        switch self.type {
        case .polygon:
            let coordinates = try container.decode([[[Double]]].self, forKey: .coordinates)
            let polygons = Geom.getPolygons(with: coordinates)
            shapes = polygons.first
            location = shapes?.coordinate
        case .multiPolygon:
            let coordinates = try container.decode([[[[Double]]]].self, forKey: .coordinates)
            let polygons = coordinates.map { Geom.getPolygons(with: $0) }.reduce([], +)
            (shapes, location) = Geom.createMultiPolygon(polygons: polygons)
        case .none:
            shapes = nil
            location = nil
        }
    }
    
    static func getPolygons(with geomCoordinates: [[[Double]]]) -> [MKPolygon] {
        let points = geomCoordinates.map { $0.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) } }
        let polygons = points.map { MKPolygon(coordinates: $0, count: $0.count) }
        return polygons
    }
    
    static func createMultiPolygon(polygons: [MKPolygon]) -> (MKPolygon?, CLLocationCoordinate2D?) {
        guard let firstPolygon = polygons.first else { return (nil, nil) }
        let othersPolygon = polygons.filter({ $0 != firstPolygon })
        let multiPolygon = MKPolygon(points: firstPolygon.points(), count: firstPolygon.pointCount, interiorPolygons: othersPolygon)
        return (multiPolygon, firstPolygon.coordinate)
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
