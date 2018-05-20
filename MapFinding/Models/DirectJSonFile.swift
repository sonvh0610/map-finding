//
//  DirectJSonFile.swift
//  MapFinding
//
//  Created by user137983 on 4/27/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation



struct northeast:Decodable {
    var lat:Float
    var lng:Float
}
struct southwest:Decodable {
    var lat:Float
    var lng:Float
}
struct bounds:Decodable {
    var northeast:northeast
    var southwest:southwest
}


struct distance:Decodable {
    var text: String
    var value: Float
}

struct duration:Decodable {
    var text: String
    var value: Float
}

struct end_location:Decodable {
    var lat:Float
    var lng: Float
}

struct start_location:Decodable {
    var lat:Float
    var lng: Float
}

struct legs:Decodable {
    var distance: distance
    var duration: duration
    var end_address: String
    var end_location: end_location
    var start_address:String
    var start_location: start_location
}


struct overview_polyline:Decodable {
    var points:String
}
struct routes:Decodable {
    var bounds: bounds
    var copyrights: String
    var legs: [legs]
    var overview_polyline: overview_polyline
    var summary: String
    var warnings:[String]
    var waypoint_order:[Int]
}

enum types: String, Decodable {
    case colloquial_area, locality, political
}

struct geocoded_waypoints:Decodable {
    var geocoder_status:String
    var place_id: String
    var types: [String]
}
struct DirectStruct:Decodable {
    var geocoded_waypoints: [geocoded_waypoints]
    var routes: [routes]
    var status:String
}







