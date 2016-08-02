//
//  MapViewViewController.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import MapKit

class MapViewViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var viewModel: MapViewViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        map?.delegate = self
        locationManager.delegate = self
        self.viewModel = MapViewViewModel(userPosition: Settings.defaultPositionNYC)
        self.viewModel?.delegate = self
        self.viewModel?.setup(locationManager)
        self.viewModel?.getISSPosition()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewViewController.addAnnotation(_:)))
        longPress.minimumPressDuration = 1.0
        map?.addGestureRecognizer(longPress)
    }
    

    func addAnnotation(gestureRecognizer:UIGestureRecognizer) {
        let alert = UIAlertController(title: "Friend name", message: "Enter your friend's name so we can alert you when the International Space Station is overhead.", preferredStyle:
            UIAlertControllerStyle.Alert)
        
        viewModel?.action(gestureRecognizer, mapView: map)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            print("name to add: \(alert.textFields![0])")
        }))
        
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func configurationTextField(textField: UITextField!)
    {
        if textField != nil {
            textField.placeholder = "Friend's name"
        }
    }

}

//MARK- MapKit delegation
extension MapViewViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didUpdateUserLocation
        userLocation: MKUserLocation) {
        
    }
}

//MARK- CoreLocation Delegation
extension MapViewViewController: CLLocationManagerDelegate {
    
}

extension MapViewViewController: MapViewViewModelDelegate {
    func didUpdateViewModel(withViewModel viewModel: MapViewViewModel) {
        self.viewModel = viewModel
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let mapView = self?.map {
                self?.viewModel?.applyISS(toMapView: mapView)
            }
        }
    }
}