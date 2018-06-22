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
        
    case let action as PlaceFindByType:
        let category = action.category
        
        category.getPlaces(currentLocation: state.currentLocation)
        break
    default:
        break
    }
    return state
}
