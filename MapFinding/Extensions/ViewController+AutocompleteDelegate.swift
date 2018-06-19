//
//  AutocompleteDelegate.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 6/16/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false

        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.placeID))")

        self.GoogleMap?.clear()
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude  , longitude: place.coordinate.longitude, zoom: 15)

        self.GoogleMap?.animate(to: camera)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = String(place.formattedAddress!)
        marker.title = String(place.name)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = self.GoogleMap
//        self.currentLat = place.coordinate.latitude
//        self.currentLong = place.coordinate.longitude
    }


    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
