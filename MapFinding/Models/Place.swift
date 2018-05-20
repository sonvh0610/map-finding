//
//  Place.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation

struct Place: Decodable {
    let Id: String
    let PlaceId: String
    let Name: String
    let Icon: String
    let Types: [String]
    let Vicinity: String
    let Geometry: GeometryLocation
    
    init(dict: [String: Any]) {
        self.Id = dict["id"] as? String ?? ""
        self.PlaceId = dict["place_id"] as? String ?? ""
        self.Name = dict["name"] as? String ?? ""
        self.Icon = dict["icon"] as? String ?? ""
        self.Types = dict["types"] as? [String] ?? []
        self.Vicinity = dict["vicinity"] as? String ?? ""
        self.Geometry = GeometryLocation(dict: dict["geometry"] as? [String: Any] ?? [:])
    }
}
