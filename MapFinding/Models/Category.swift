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
import PromiseKit

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
    
    func getPlaces(currentLocation: CLLocation) -> Promise<[Place]> {
        return Promise<[Place]> { seal -> Void in
            self.instance.getPlaces(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude, type: self.name).done { results in
                seal.fulfill(results)
            }
        }
    }
}
