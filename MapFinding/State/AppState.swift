//
//  AppState.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift

struct PlaceState: StateType {
    var listPlaces: [Place] = []
}

struct FilterState: StateType {
    var selectedFeature: Int = -1
}

struct AppState: StateType {
    var place: PlaceState = PlaceState()
    var filter: FilterState = FilterState()
}
