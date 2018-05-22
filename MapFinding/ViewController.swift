//
//  ViewController.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 4/14/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

var APIKey = "AIzaSyCqfMT5I-TaHa0-D7T4JrhCglzXxSALWc0"

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    

    var currentLat: Double = 0.0
    var currentLong: Double = 0.0
    
    var myPlaces = [iPlace]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var featureBtn: UIButton!
    @IBOutlet weak var featurePickerTxt: UITextField!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var GoogleMap: GMSMapView?
    
    let featurePicker = UIPickerView()
    let locationManager = CLLocationManager()

    let listSelectFeatures = ["atm", "gas_station", "hospital","police","cafe"]
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false

        initFeaturePicker()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
    }
    
  
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        showCurrentLocationOnMap(location: location)
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.longitude
        locationManager.stopUpdatingLocation()
    }
    
    func initFeaturePicker() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.onSelectFeaturePicker))
        toolbar.setItems([doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        featurePicker.delegate = self
        featurePicker.dataSource = self
        featurePickerTxt.inputView = featurePicker
        featurePickerTxt.inputAccessoryView = toolbar
        featurePickerTxt.isHidden = true
    }
    
    @objc func onSelectFeaturePicker() {
        featurePickerTxt.resignFirstResponder()
    }
    
    func showCurrentLocationOnMap(location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18)
        GoogleMap = GMSMapView.map(withFrame: CGRect.init(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height), camera: camera)
        self.mapView.addSubview(GoogleMap!)
        
        GoogleMap?.settings.myLocationButton = true
        GoogleMap?.isMyLocationEnabled = true
    
 
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current Location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: .blue);
        marker.map = GoogleMap
        
        
        
      
        
        
        // Lay dia chi tu autocomplete search  ??
//        let str = "Facebook Way, Menlo Park, CA 94025, USA"
//        let temp = str.replacingOccurrences(of: " ", with: "+")
//        let Address = temp.replacingOccurrences(of: ",", with: "")
//        configureMAP().getDirection(lat: location.coordinate.latitude, lng: location.coordinate.longitude,Address: Address, APIKey: APIKey) { myDirection in
//            for route in myDirection.routes {
//                DispatchQueue.main.async {
//                    let points = route.overview_polyline.points
//                    let path = GMSPath.init(fromEncodedPath:points)
//                    let polyline = GMSPolyline.init(path:path)
//                    polyline.strokeWidth = 4
//                    polyline.strokeColor = UIColor.red
//                    polyline.map = mapView
//                }
//            }
//        }
        
        
    }
    
 

    
    
    
    @IBAction func onSelectFeature(_ sender: UIButton) {
        featurePickerTxt.becomeFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listSelectFeatures.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(listSelectFeatures[row], comment: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        featurePickerTxt.text =  NSLocalizedString(listSelectFeatures[row], comment: "")
        
        self.GoogleMap?.clear()
        PlaceFinder.getPlaces(lat: currentLat, lng: currentLong, type: listSelectFeatures[row], range: 5000).done
            { atm  in
                for each in atm {
                    var newMarker = GMSMarker()
                    newMarker = configureMAP().drawPlaceByType(place: each, name: " ", type: self.listSelectFeatures[row]) // truyen type tu view picker
                    newMarker.map = self.GoogleMap

            }
        }
        
 
    }
}


extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.placeID))")
  
        self.GoogleMap?.clear()
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude  , longitude: place.coordinate.longitude, zoom: 18)
        self.GoogleMap?.camera = camera
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = String(place.formattedAddress!)
        marker.title = String(place.name)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = self.GoogleMap
    }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
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
