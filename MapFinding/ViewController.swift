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


var APIKey = "AIzaSyCodndO4xHHgof1F3omVMpxJ_kNy1-8x18"


class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    
    var BenThanhLat = 10.772329
    var BenThanhLong = 106.698338
    var rectangle = GMSPolygon()
    var myPlaces = [iPlace]()
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var featureBtn: UIButton!
    @IBOutlet weak var featurePickerTxt: UITextField!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    
    let featurePicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    let listSelectFeatures = ["atm", "gas_station", "store", "park", "hospital"]
    
    
    
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
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
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
        showCurrentLocationOnMap()
    
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
    
    func showCurrentLocationOnMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: BenThanhLat, longitude: BenThanhLong, zoom: 18)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 10.772329, y: 106.698338, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height), camera: camera)
        self.mapView.addSubview(mapView)
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
      
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Current Location"
        marker.title = "asdasd"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: .black);
        marker.map = mapView
        
        
        
//        getLocationByType(type: "restaurant") { myATM in
//            for eachResult in myATM.results{
//                DispatchQueue.main.async {
//                    var newMarker = GMSMarker()
//                    newMarker = self.findByID(placeID: eachResult.place_id)
//                    newMarker.map = mapView
//                }
//            }
//        }
//
//        getDirection() { myDirection in
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
//
//        }
        
    
    
        
        
    }
    
    
    func getLocationByType (type:String, completion: @escaping (myJSONFile) -> () ) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=\(BenThanhLat)%2C\(BenThanhLong)&radius=5000&type=\(type)&key=AIzaSyARC_KcLUdCs9ZEU3i5LTPPTdoFzi_BIcI") else { return}
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            guard let data = data else {return}
            print(data)
            do {
                let place = try JSONDecoder().decode(myJSONFile.self,from:data)
                completion(place);
            }
            catch {
                print("Error query place")
            }
            }.resume()
    }

    
   
    
    func getDirection (completion : @escaping  ( DirectStruct) -> () ) {
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=Ben+Thanh+Viet+Nam&destination=Dai+Hoc+Khoa+hoc+Tu+Nhien4&key=AIzaSyCodndO4xHHgof1F3omVMpxJ_kNy1-8x18") else { return}
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
    
    
    
    
    
    func findByID (placeID:String) ->GMSMarker {
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
            print ("Place name \(place.name)")
            print ("Place address \(place.formattedAddress)")
            print (place.coordinate)
            placeMarker.title = place.name
            placeMarker.snippet = place.formattedAddress
            placeMarker.position.latitude = place.coordinate.latitude
            placeMarker.position.longitude = place.coordinate.longitude
            placeMarker.icon = GMSMarker.markerImage(with: .blue)
            
        })
        return placeMarker
    }
    
    
    
        // CircleK Ben thanh 10.774383 - 106.696235
    
   
    
    
    
    
    
    
    
    
    
    
    
    
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
        return listSelectFeatures[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        featurePickerTxt.text = listSelectFeatures[row]
    }
}


extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.placeID))")
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude  , longitude: place.coordinate.longitude, zoom: 18)
        let mapView = GMSMapView.map(withFrame: CGRect.init(x: 10.772329, y: 106.698338, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height), camera: camera)
        self.mapView.addSubview(mapView)
        
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = String(place.formattedAddress!)
        marker.title = String(place.name)
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = GMSMarker.markerImage(with: .red);
        marker.map = mapView
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
