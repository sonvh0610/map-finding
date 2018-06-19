//
//  MapViewDelegate.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/17/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps

//extension ViewController: GMSMapViewDelegate {
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        guard let data = marker.userData as? String else { return false }
//        self.directionButton.isHidden = false
//        self.mapView.addSubview(directionButton)
//        let parseData = data.components(separatedBy: "+")
//        self.Address = parseData[0]
//        self.placeID = parseData[1]
//        mapView.moveCamera(GMSCameraUpdate.zoom(by: 2))
//        return false
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        self.directionButton.isHidden = true
//    }
//
//    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
//        self.currentLong = (mapView.myLocation?.coordinate.longitude)!
//        self.currentLat = (mapView.myLocation?.coordinate.latitude)!
//
//        return false
//    }
//}
