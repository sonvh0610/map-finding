//
//  Geometry.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation

struct GeometryLocation: Decodable {
    let Location: Coordinates
    
    init(dict: [String: Any]) {
        self.Location = Coordinates(dict: dict["location"] as? [String: Any] ?? [:])
    }
}

struct Coordinates: Decodable {
    let Latitude: Double
    let Longitude: Double
    
    init(dict: [String: Any]) {
        self.Latitude = dict["lat"] as? Double ?? 0
        self.Longitude = dict["lng"] as? Double ?? 0
    }
}
