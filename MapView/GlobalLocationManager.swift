//
//  GlobalLocationManager.swift
//  Organix
//
//  Created by Cordero Hernandez on 12/7/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation
import MapKit
import UIKit

class GlobalLocationManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    static let instance = GlobalLocationManager()
    private override init() {}
    
    private var alreadyInitialized = false
    private var onLocation: ((CLLocationCoordinate2D) -> Void)?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var currentRegion: MKCoordinateRegion?
    var currentStatus: CLAuthorizationStatus?
    
    var currentCoordinate: CLLocationCoordinate2D? {
        return currentLocation?.coordinate
    }
    
    func initialize() {
        
        if alreadyInitialized {
            
            LOG.info("Location Manager already initialized")
            return
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        alreadyInitialized = true
    }
    
    func requestLocation(callback: @escaping ((CLLocationCoordinate2D) -> Void)) {
        
        if !alreadyInitialized {
            initialize()
        }
        
        self.onLocation = callback
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location: CLLocation = locations.first else {
            
            LOG.error("Failed to get location")
            return
        }
        
        defer {
            locationManager.stopUpdatingLocation()
        }
        
        self.currentLocation = location
        let region = calculateRegion(for: location.coordinate)
        self.currentRegion = region
        
        onLocation?(location.coordinate)
        onLocation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .restricted:
            //Make Aroma Note That Access is Restricted
            break
            
        case .denied:
            //Make Aroma Note that Access is Denied
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            //Make Aroma note that Access Granted
            break
            
        default:
            //Make Aroma note that Acess is Undetermined
            break
        }
        
        self.currentStatus = status
    }
    
    internal func calculateRegion(for location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        
        let latitude = location.latitude
        let longitude = location.longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        return region
    }
    
}



