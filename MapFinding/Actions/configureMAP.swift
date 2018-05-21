//
//  configureMAP.swift
//  MapFinding
//
//  Created by user137983 on 5/21/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation

class configureMAP: UIViewController {

func drawPlaceByType (place:Place, name:String) ->GMSMarker {
    let placeMarker = GMSMarker()
    let placeNameUpper = place.Name.uppercased()
    let nameUpper = name.uppercased()
    var open = NSLocalizedString("Tình trạng: ", comment: "")

    if ( place.Open.open_now == true) {
        open  += NSLocalizedString("Đang hoạt động", comment: "")
    }
    else {
        open += NSLocalizedString("Đã Đóng", comment: "")
    }
    if ( placeNameUpper.contains(nameUpper) == true) {

       
        placeMarker.title = place.Name
        placeMarker.snippet = place.Vicinity + "\n" +   NSLocalizedString(open, comment: "")
        placeMarker.position.latitude = place.Geometry.Location.Latitude
        placeMarker.position.longitude = place.Geometry.Location.Longitude
        placeMarker.icon = GMSMarker.markerImage(with: .black)
        
    }
    return placeMarker
    }
    
    
    func getDirection (lat:Double, lng:Double,Address:String,APIKey: String,completion : @escaping  ( DirectStruct) -> () ) {
       
       
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(lat),\(lng)&destination=\(Address)4&key=\(APIKey)") else { return}
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            guard let data = data else {return}
            print(data)
            do {
                let direct = try JSONDecoder().decode(DirectStruct.self,from:data)
                completion(direct);
            }
            catch {
                print("Error query place")
            }
            }.resume()
        
    }
    
}
