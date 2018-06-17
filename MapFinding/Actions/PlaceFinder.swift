//
//  PlaceFinder.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 5/20/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class PlaceFinder {
    static public func getPlaces(lat: Double, lng: Double, type: String, range: Int) -> Promise<[Place]> {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=\(range)&type=\(type)&key=\(Constants.GOOGLE_API_KEY)"
        
        return Promise<[Place]> { seal -> Void in
            Alamofire.request(url)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        let dict = json as! [String: Any]
                        var places: [Place] = []
                        
                        for place in dict["results"] as! [[String:Any]] {
                            places.append(Place(dict: place))
                        }
                        
                        seal.fulfill(places)
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
        }
    }
}
