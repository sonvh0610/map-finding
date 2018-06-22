//
//  FilterReducer.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/19/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift

func filterReducer(action: Action, state: FilterState?) -> FilterState {
    var state = state ?? FilterState()
    
    switch (action) {
    case let action as SelectFeatureIndex:
        state.selectedFeature = action.index
        break
        
    default:
        break
    }
    
    return state
}
