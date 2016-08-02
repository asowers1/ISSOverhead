//
//  MapViewViewModel.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Alamofire
import Argo
import MapKit
import ASUserDefaults

class ISSPointAnnoation: MKPointAnnotation {
    
}

protocol MapViewViewModelDelegate: class {
    func didUpdateViewModel(withViewModel viewModel: MapViewViewModel)
}

struct MapViewViewModel {
    let userPosition: Position
    var iSSNow: ISSNow?
    var activeAnnotation: MKPointAnnotation?
    weak var delegate: MapViewViewModelDelegate?
    init(userPosition: Position) {
        self.userPosition = userPosition
    }
    
    lazy var scheduler: Scheduler = {
        TaskScheduler()
    }()
    
    var scheduledTask: ScheduledTaskType? = nil {
        willSet {
            self.scheduledTask?.cancel()
        }
    }
    
    mutating func getISSPosition() {
        Alamofire.request(.GET, "http://api.open-notify.org/iss-now.json")
            .responseJSON { response in
                
                if let json = response.result.value {
                    if let iSSNow = ISSNow.decode(JSON(json)).value {
                        self.iSSNow = iSSNow
                        self.delegate?.didUpdateViewModel(withViewModel: self)
                    }
                }
                
                self.scheduledTask = self.scheduler.scheduleTask({
                    self.getISSPosition()
                    }, delay: 4.0)
        }
        
    }
    
    mutating func applyISS(toMapView mapView: MKMapView) -> Bool {
        guard let iSSNow = self.iSSNow?.position else { return false }
        mapView.annotations.forEach({
            if let currentISSPosition = $0 as? ISSPointAnnoation {
                mapView.removeAnnotation(currentISSPosition)
            }
        })
        let coordinate = CLLocationCoordinate2D(latitude: iSSNow.lat, longitude: iSSNow.lon)
        let annotation = ISSPointAnnoation()
        annotation.coordinate = coordinate
        annotation.title = "ISS"
        annotation.subtitle = "lat: \(coordinate.latitude) lon: \(coordinate.longitude)"
        mapView.addAnnotation(annotation)
//        let region = MKCoordinateRegionMake(coordinate, mapView.region.span)
//        mapView.setRegion(region, animated: true)
        return true
    }
    
    func setup(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = true
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.startUpdatingLocation()
            
        } else {
            
            print("locationServices disenabled")
        }
    }
    
    mutating func action(gestureRecognizer:UIGestureRecognizer, mapView: MKMapView) {
        let touchPoint = gestureRecognizer.locationInView(mapView)
        let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        mapView.addAnnotation(newAnotation)
        self.activeAnnotation = newAnotation
    }
    
    func updateAnnotationText(withAnnotation annotation: MKPointAnnotation, withTitle title: String) {
        annotation.title = title
        annotation.subtitle = "lat: \(annotation.coordinate.latitude) lon: \(annotation.coordinate.longitude)"
    }
}