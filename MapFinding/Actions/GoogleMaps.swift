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
import SwiftyJSON

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
    
    public func getPlaces(lat: Double, lng: Double, type: String) -> Promise<[Place]> {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&rankby=distance&type=\(type)&key=\(Constants.GOOGLE_API_KEY)"
        
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
    
    public func showDirections(from: CLLocation, to: CLLocation) -> Promise<[String]> {
        let origin = "\(from.coordinate.latitude),\(from.coordinate.longitude)"
        let destination = "\(to.coordinate.latitude),\(to.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking"
        
        return Promise<[String]> { seal -> Void in
            Alamofire.request(url).responseJSON { response in
                do {
                    let json = try JSON(data: response.data!)
                    let routes = json["routes"].arrayValue
                    
                    for route in routes {
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        let path = GMSPath.init(fromEncodedPath: points!)
                        let polyline = GMSPolyline.init(path: path)
                        let bounds = GMSCoordinateBounds(path: path!)
                        polyline.map = self.MapInstance
                        self.MapInstance?.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(100.0, 50.0, 280.0, 50.0)))
                    }
                    
                    seal.fulfill([
                        routes[0]["legs"][0]["distance"]["text"].stringValue,
                        routes[0]["legs"][0]["duration"]["text"].stringValue
                    ])
                }
                catch {
                    seal.reject("Direction error occurs!" as! Error)
                }
            }
        }
    }
}
