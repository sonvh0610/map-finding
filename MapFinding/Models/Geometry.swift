//
//  Geometry.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation

struct GeometryLocation: Decodable {
    var Location: Coordinates = Coordinates()
    
    init(dict: [String: Any]) {
        self.Location = Coordinates(dict: dict["location"] as? [String: Any] ?? [:])
    }
    
    init() {
        
    }
}

struct Coordinates: Decodable {
    var Latitude: Double = 0
    var Longitude: Double = 0
    
    init(dict: [String: Any]) {
        self.Latitude = dict["lat"] as? Double ?? 0
        self.Longitude = dict["lng"] as? Double ?? 0
    }
    
    init() {
        
    }
}
