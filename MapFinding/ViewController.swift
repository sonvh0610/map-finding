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

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var featureBtn: UIButton!
    @IBOutlet weak var featurePickerTxt: UITextField!
    
    var currentLat: Double = 0.0
    var currentLong: Double = 0.0
    var currentPosition: CLLocation = CLLocation()
    
    var listSelectFeatures: [Category] = []
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var GoogleMap: GMSMapView?
    
    let featurePicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    let googleMapsComponent = GoogleMapsComponent.shared;
    
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
        
        // Init categories
        for item in ["atm", "gas_station", "hospital","police", "cafe"] {
            listSelectFeatures.append(Category(name: item))
        }

        directionButton.setBackgroundImage(UIImage(named: "directions.png"), for: .normal)

        // Do any additional setup after loading the view, typically from a nib.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
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
        googleMapsComponent.showCurrentLocation(location: location, mapView: self.mapView)
        currentLat = location.coordinate.latitude
        currentLong = location.coordinate.longitude
        self.currentPosition = location
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
    
 
    var Address:String = ""
    var placeID:String = ""
    @IBAction func actionDirectionButton(_ sender: Any)
    {
        self.GoogleMap?.clear()
        
        
        DispatchQueue.main.async {
            let id = self.placeID
            var newMarker = GMSMarker()
            newMarker = configureMAP().drawPlaceByPlaceID(placeID: id)
            newMarker.map = self.GoogleMap
        }
        
        
        let temp = self.Address.replacingOccurrences(of: " ", with: "+")
        let Address = temp.replacingOccurrences(of: ",", with: "")
        configureMAP().getDirection(lat: (self.GoogleMap?.myLocation?.coordinate.latitude)!, lng: (self.GoogleMap?.myLocation?.coordinate.longitude)!,Address: Address, APIKey: Constants.GOOGLE_API_KEY)
        {
            myDirection in
            var polyline = GMSPolyline()
            for route in myDirection.routes
            {
                DispatchQueue.main.async
                    {
                    let points = route.overview_polyline.points
                    let path = GMSPath.init(fromEncodedPath:points)
                    polyline = GMSPolyline.init(path:path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.isTappable = true
                    polyline.map = self.GoogleMap
                    }
            }
        }
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
        return NSLocalizedString(listSelectFeatures[row].Name, comment: "")
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.GoogleMap?.clear()
        listSelectFeatures[row].getPlaces(currentLocation: currentPosition, range: 5000)
        self.directionButton.isHidden = true
 
    }
}
