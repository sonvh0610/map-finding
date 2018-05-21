//
//  Place.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation


struct opening_hours: Decodable {
    let open_now: Bool

    
    init(dict: [String: Any]) {
        self.open_now = dict["open_now"] as? Bool ?? false
       
    }
}

struct Place: Decodable {
    let Id: String
    let PlaceId: String
    let Name: String
    let Icon: String
    let Types: [String]
    let Vicinity: String
    let Geometry: GeometryLocation
    let Open: opening_hours
    
    init(dict: [String: Any]) {
        self.Id = dict["id"] as? String ?? ""
        self.PlaceId = dict["place_id"] as? String ?? ""
        self.Name = dict["name"] as? String ?? ""
        self.Icon = dict["icon"] as? String ?? ""
        self.Types = dict["types"] as? [String] ?? []
        self.Vicinity = dict["vicinity"] as? String ?? ""
        self.Geometry = GeometryLocation(dict: dict["geometry"] as? [String: Any] ?? [:])
        self.Open = opening_hours(dict: dict["opening_hours"] as? [String: Any] ?? [:])
    }
}
