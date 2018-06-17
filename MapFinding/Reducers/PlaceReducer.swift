//
//  PlaceReducer.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift

func placeReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch (action) {
    case let action as PlaceFindByType:
        var category = action.category
        var currentLocation = action.currentLocation
        
        category.getPlaces(currentLocation: currentLocation, range: 5000)
        return state
    default:
        return state
    }
}
