//
//  Category.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/16/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import AwaitKit

class Category {
    private var name = ""
    private var instance: GoogleMapsComponent
    
    var Name: String {
        get { return self.name }
        set { self.name = newValue }
    }
    
    init(name: String) {
        self.name = name
        self.instance = GoogleMapsComponent.shared
    }
    
    func getPlaces(currentLocation: CLLocation, range: Int) {
        let results = try! await(instance.getPlaces(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, type: self.name, range: range))
        print(results)
        for place in results {
            let marker = GMSMarker()
            marker.title = place.Name
            marker.snippet = place.Vicinity
            marker.position.latitude = place.Geometry.Location.Latitude
            marker.position.longitude = place.Geometry.Location.Longitude
            marker.appearAnimation = .pop
            marker.userData = place.PlaceId
            marker.map = self.instance.MapInstance
        }
    }
}
