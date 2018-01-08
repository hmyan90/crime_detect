//
//  ViewController.swift
//  Detection
//
//  Created by huimin on 2017/12/17.
//  Copyright © 2017年 huimin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var googleMap: GMSMapView!
    @IBOutlet weak var CrimeLocation: UITextField!
    @IBOutlet weak var CrimeDetail: UILabel!
    
    var locationManager = CLLocationManager()
    var selectedLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.621262, longitude: -122.379084, zoom: 12)
        self.googleMap.camera = camera
        self.googleMap.delegate = self
        self.googleMap?.isMyLocationEnabled = true
        self.googleMap.settings.myLocationButton = true
        self.googleMap.settings.compassButton = true
        self.googleMap.settings.zoomGestures = true
        
        // Creates a marker in the center of the map.
        createMarker(titleMarker: "SFO Airport", latitude: 37.621262, longitude: -122.379084)
        
    }
    
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
//        marker.icon = iconMarker
        marker.map = googleMap
    }
    
    func showCrimeDetail(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        // TODO
        self.CrimeDetail.text = "100"
    }
    
    @IBAction func Location(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        CrimeLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
        selectedLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        createMarker(titleMarker: "Location", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        self.googleMap.camera = camera
        self.dismiss(animated: true, completion: nil)
        self.showCrimeDetail(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}

