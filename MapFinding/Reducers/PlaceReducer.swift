//
//  PlaceReducer.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift

func placeReducer(action: Action, state: PlaceState?) -> PlaceState {
    var state = state ?? PlaceState()
    
    switch (action) {
    case let action as SaveCurrentLocation:
        state.currentLocation = action.currentLocation
        break
        
    case let action as SaveListPlaces:
        state.listPlaces = action.places
        break
        
    case let action as SelectPlace:
        state.selectedPlaceIndex = action.index
        break
        
    default:
        break
    }
    return state
}
