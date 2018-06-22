//
//  Place.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift
import GooglePlaces

struct SaveCurrentLocation: Action {
    var currentLocation: CLLocation
}

struct PlaceFindByType: Action {
    var category: Category
}
