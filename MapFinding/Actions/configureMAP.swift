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

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

class configureMAP: UIViewController {

    func drawPlaceByType (place:Place, name:String, type:String) ->GMSMarker {
    let placeMarker = GMSMarker()
    let placeNameUpper = place.Name.uppercased()
    let nameUpper = name.uppercased()
    var open = NSLocalizedString("Tình trạng: ", comment: "")

    if ( place.Open.OpenNow == true) {
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
        placeMarker.appearAnimation = GMSMarkerAnimation.pop
        placeMarker.icon = imageWithImage(image: UIImage(named: type + ".png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
        //        placeMarker.icon = GMSMarker.markerImage(with: .black)
        placeMarker.userData = place.Vicinity + "+" + place.PlaceId
        
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
    
    func drawPlaceByPlaceID (placeID:String) -> GMSMarker{
        let placeMarker = GMSMarker()
        let placesClient = GMSPlacesClient()
    
            placesClient.lookUpPlaceID(placeID,callback: { (place, error) in
                if let error = error {
                    print ("lookup error: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print( "No details ")
                    return
                }
                placeMarker.title = place.name
                placeMarker.snippet = place.formattedAddress
                placeMarker.position.latitude = place.coordinate.latitude
                placeMarker.position.longitude = place.coordinate.longitude
                placeMarker.appearAnimation = GMSMarkerAnimation.pop
                placeMarker.icon = GMSMarker.markerImage(with: .red)
            
            })
        return placeMarker
        
    }
    
}
