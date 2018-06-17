//
//  GoogleMapsAdapter.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/15/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import PromiseKit
import Alamofire

final class GoogleMapsComponent {
    static let shared: GoogleMapsComponent = GoogleMapsComponent();
    private var mapInstance: GMSMapView?
    
    var MapInstance: GMSMapView? {
        get { return self.mapInstance }
    }
    
    private init() {}
    
    func showCurrentLocation(location: CLLocation, mapView: UIView) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
        mapInstance = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: mapView.frame.size.width, height: mapView.frame.size.height), camera: camera)
        mapView.addSubview(mapInstance!)
        
        mapInstance?.settings.myLocationButton = true
        mapInstance?.isMyLocationEnabled = true
        //mapInstance?.delegate = self
    }
    
    public func getPlaces(lat: Double, lng: Double, type: String, range: Int) -> Promise<[Place]> {
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
                        
                        print(places)
                        
                        seal.fulfill(places)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}
