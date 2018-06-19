//
//  AppReducer.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/19/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        place: placeReducer(action: action, state: state?.place),
        filter: filterReducer(action: action, state: state?.filter)
    )
}
