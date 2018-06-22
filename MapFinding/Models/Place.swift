//
//  Place.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation


struct OpeningHours: Decodable {
    var OpenNow: Bool = false

    init(dict: [String: Any]) {
        self.OpenNow = dict["open_now"] as? Bool ?? false
    }
    
    init() {
        
    }
}

struct Place: Decodable {
    var Id: String = ""
    var PlaceId: String = ""
    var Name: String = ""
    var Icon: String = ""
    var Types: [String] = []
    var Vicinity: String = ""
    var Geometry: GeometryLocation = GeometryLocation()
    var Open: OpeningHours = OpeningHours()
    
    init(dict: [String: Any]) {
        self.Id = dict["id"] as? String ?? ""
        self.PlaceId = dict["place_id"] as? String ?? ""
        self.Name = dict["name"] as? String ?? ""
        self.Icon = dict["icon"] as? String ?? ""
        self.Types = dict["types"] as? [String] ?? []
        self.Vicinity = dict["vicinity"] as? String ?? ""
        self.Geometry = GeometryLocation(dict: dict["geometry"] as? [String: Any] ?? [:])
        self.Open = OpeningHours(dict: dict["opening_hours"] as? [String: Any] ?? [:])
    }
}


