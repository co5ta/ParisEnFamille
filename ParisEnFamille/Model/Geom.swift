//
//  Geom.swift
//  ParisEnFamille
//
//  Created by co5ta on 28/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import MapKit

/// Geom decodes the location of a green space and generates its polygon
struct Geom: Decodable {
    
    /// Type of the geom
    let type: GeomType?
    /// Polygon of the geom
    let shapes: MKPolygon?
    /// Location of the geom
    let location: CLLocationCoordinate2D?
    
    /// Creates a new instance by decoding the data from the json
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
        default:
            shapes = nil
            location = nil
        }
    }
    
    /// Fetchs all polygons availablein the green space data
    static func getPolygons(with geomCoordinates: [[[Double]]]) -> [MKPolygon] {
        let points = geomCoordinates.map { $0.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) } }
        let polygons = points.map { MKPolygon(coordinates: $0, count: $0.count) }
        return polygons
    }
    
    /// Creates a multypolygon from all the recovered polygons
    static func createMultiPolygon(polygons: [MKPolygon]) -> (MKPolygon?, CLLocationCoordinate2D?) {
        guard let firstPolygon = polygons.first else { return (nil, nil) }
        let othersPolygon = polygons.filter({ $0 != firstPolygon })
        let multiPolygon = MKPolygon(points: firstPolygon.points(), count: firstPolygon.pointCount, interiorPolygons: othersPolygon)
        return (multiPolygon, firstPolygon.coordinate)
    }
    
    /// Enum of keys to decode data from the json
    enum CodingKeys: CodingKey {
        case type
        case coordinates
    }
    
    /// Enum  of type polygon types
    enum GeomType: String, CaseIterable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }
}
