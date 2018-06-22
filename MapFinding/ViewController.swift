//
//  ViewController.swift
//  MapFinding
//
//  Created by Hoai-Son Vo on 4/14/18.
//  Copyright © 2018 University of Science. All rights reserved.
//

import UIKit
import ReSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import Material
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, StoreSubscriber {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var featureBtn: UIButton!
    @IBOutlet weak var featurePickerTxt: UITextField!
    
    var listSelectFeatures: [Category] = []
    let googleMapsComponent = GoogleMapsComponent.shared;
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var GoogleMap: GMSMapView?
    
    let featurePicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    var placeCard: Card!
    var toolbar: Toolbar!
    var contentView: UILabel!
    var bottomBar: Bar!
    var closeButton: IconButton!
    var favoriteButton: IconButton!
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
        image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func newState(state: AppState) {
        // code
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init categories
        for item in ["atm", "gas_station", "hospital","police", "cafe"] {
            listSelectFeatures.append(Category(name: item))
        }

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

        self.initFeaturePicker()
        prepareFavoriteButton()
        prepareCloseButton()
        prepareToolbar()
        prepareContentView()
        prepareBottomBar()
        prepareCard()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        googleMapsComponent.showCurrentLocation(location: location, mapView: self.mapView)
        mainStore.dispatch(SaveCurrentLocation(currentLocation: location))
        
        locationManager.stopUpdatingLocation()
    }
    
    func prepareCard() {
        placeCard = Card()
        
        placeCard.toolbar = toolbar
        placeCard.toolbarEdgeInsetsPreset = .square3
        placeCard.toolbarEdgeInsets.bottom = 0
        placeCard.toolbarEdgeInsets.right = 8
        
        placeCard.contentView = contentView
        placeCard.contentViewEdgeInsetsPreset = .wideRectangle3
        
        placeCard.bottomBar = bottomBar
        placeCard.bottomBarEdgeInsetsPreset = .wideRectangle2
        placeCard.isHidden = true
        
        view.layout(placeCard).horizontally(left: 10, right: 10).height(150).bottom(20)
    }
    
    func prepareContentView() {
        contentView = UILabel()
        contentView.numberOfLines = 0
        contentView.text = "Material is an animation and graphics framework that is used to create beautiful applications."
        contentView.font = RobotoFont.regular(with: 14)
    }
    
    func prepareToolbar() {
        toolbar = Toolbar(rightViews: [closeButton])
        
        toolbar.title = "Material"
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textAlignment = .left
        toolbar.detailLabel.textColor = Color.grey.base
    }
    
    func prepareFavoriteButton() {
        favoriteButton = IconButton(image: Icon.favorite, tintColor: Color.red.base)
        favoriteButton.addTarget(self, action: #selector(self.onBookmarkTapped), for: .touchUpInside)
    }
    
    @objc private func onBookmarkTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context)
        let bookmark = NSManagedObject(entity: entity!, insertInto: context)
        
        let listPlaces = mainStore.state.place.listPlaces
        let selectedPlaceIndex = mainStore.state.place.selectedPlaceIndex
        
        bookmark.setValue(listPlaces[selectedPlaceIndex].Id, forKey: "id")
        bookmark.setValue(listPlaces[selectedPlaceIndex].Name, forKey: "name")
        bookmark.setValue(listPlaces[selectedPlaceIndex].Vicinity, forKey: "address")
        
        do {
            try context.save()
        }
        catch {
            print("Save context failed")
        }
    }
    
    func prepareCloseButton() {
        closeButton = IconButton(image: Icon.cm.close, tintColor: Color.grey.base)
        closeButton.addTarget(self, action: #selector(self.onCloseButtonTapped), for: .touchUpInside)
        self.googleMapsComponent.MapInstance?.clear()
    }
    
    @objc private func onCloseButtonTapped() {
        self.placeCard.isHidden = true
    }
    
    func prepareBottomBar() {
        bottomBar = Bar()
        
        bottomBar.leftViews = [favoriteButton]
//        bottomBar.rightViews = [dateLabel]
    }

    
    func initFeaturePicker() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onSelectFeaturePicker))
        let btnSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        btnSpacer.width = UIScreen.main.bounds.width - 50
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.onCancelFeaturePicker))
        toolbar.setItems([doneBtn, btnSpacer, cancelBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        featurePicker.delegate = self
        featurePicker.dataSource = self
        featurePickerTxt.inputView = featurePicker
        featurePickerTxt.inputAccessoryView = toolbar
        featurePickerTxt.isHidden = true
    }
    
    @objc func onSelectFeaturePicker() {
        featurePickerTxt.resignFirstResponder()
        self.googleMapsComponent.MapInstance?.clear()
        
        let selectedFeatureIndex = mainStore.state.filter.selectedFeature
        listSelectFeatures[selectedFeatureIndex].getPlaces(currentLocation: mainStore.state.place.currentLocation).done{ results in
            mainStore.dispatch(SaveListPlaces(places: results))
            if (results.count > 0) {
                let dest = CLLocation(latitude: results[0].Geometry.Location.Latitude, longitude: results[0].Geometry.Location.Longitude)
                self.googleMapsComponent.showDirections(from: mainStore.state.place.currentLocation, to: dest)
                
                self.placeCard.isHidden = false
                self.toolbar.title = results[0].Name
                self.toolbar.detail = results[0].Vicinity
                
                mainStore.dispatch(SelectPlace(index: 0))
            }
        }
    }
    
    @objc private func onCancelFeaturePicker() {
        self.featurePickerTxt.resignFirstResponder()
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
        mainStore.dispatch(SelectFeatureIndex(index: row))
    }
}
