//
//  AppState.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift
import GooglePlaces

struct PlaceState: StateType {
    var currentLocation: CLLocation = CLLocation()
    var listPlaces: [Place] = []
    var selectedPlaceIndex: Int = 0
}

struct FilterState: StateType {
    var selectedFeature: Int = 0
}

struct AppState: StateType {
    var place: PlaceState = PlaceState()
    var filter: FilterState = FilterState()
}
