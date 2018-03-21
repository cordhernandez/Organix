//
//  BusinessesMapViewController.swift
//  Organix
//
//  Created by Cordero Hernandez on 12/13/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation
import Kingfisher
import MapKit
import UIKit

class BusinessesMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentCoordinate: CLLocationCoordinate2D?
    var selectedPin: MKPlacemark?
    
    var businesses: [Businesses] = []
    var distance = 0.0
    
    var showVeganBusinesses: Bool {
        return UserPreferences.instance.showVeganBusinesses
    }
    
    var showVegetarianBusinesses: Bool {
        return UserPreferences.instance.showVegetarianBusinesses
    }
    
    var useMyLocation: Bool {
        return UserPreferences.instance.useMyLocation
    }
    
    var useZipCode: Bool {
        return UserPreferences.instance.useZipCode
    }
    
    var useCity: Bool {
        return UserPreferences.instance.useCity
    }
    
    var zipCode: String {
        return UserPreferences.instance.zipCode ?? ""
    }
    
    var city: String {
        return UserPreferences.instance.city ?? ""
    }
    
    fileprivate let async: OperationQueue = {
       
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 2
        
        return operationQueue
    }()
    
    fileprivate let main = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareMapView()
        loadBusinesses()
        //Make Note that User Entered Map View
    }
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    private func prepareMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if useMyLocation, let region = GlobalLocationManager.instance.currentRegion {
            
            self.mapView.setRegion(region, animated: true)
        }
        
        //Let the user explore the map on their own
    }
}

//MARK: - Load Businesses Into MapView
internal extension BusinessesMapViewController {
    
    fileprivate func loadBusinesses() {
        
        if useMyLocation {
            
            GlobalLocationManager.instance.requestLocation(callback: self.loadBusinessesAtCoordinate)
        }
        else if useZipCode, zipCode.isNotEmpty {
            
            loadBusinessesAtZipCode(zipCode: zipCode)
        }
        else if useCity, city.isNotEmpty {
            
            loadBusinessesAtCity(city: city)
        }
    }
    
    func loadBusinessesAtCoordinate(coordinate: CLLocationCoordinate2D) {
        
        startSpinningIndicator()
        SearchBusinesses.searchForBusinessesLocations(near: coordinate, callback: self.populateBusinesses)
    }
    
    func loadBusinessesAtCity(city: String) {
        
        startSpinningIndicator()
        SearchBusinesses.searchForBusinessesByCity(withCity: city, callback: self.populateBusinesses)
    }
    
    func loadBusinessesAtZipCode(zipCode: String) {
        
        startSpinningIndicator()
        SearchBusinesses.searchForBusinessesByZipCode(withZipCode: zipCode, callback: self.populateBusinesses)
    }
    
    private func populateBusinesses(businesses: [Businesses]) {
        
        self.businesses = businesses
        
        self.main.addOperation {
            
            self.populateBusinessAnnotations()
            self.stopSpinningIndicator()
        }
        
        if self.businesses.isEmpty {
            
            //Make a note that businesses are empty
        }
    }
    
    func populateBusinessAnnotations() {
        
        var annotations: [MKAnnotation] = []
        
        for business in businesses {
            
            let customAnnotation = createAnnotation(forBusinesses: business)
            annotations.append(customAnnotation)
        }
        
        mapView.addAnnotations(annotations)
        mapView.removeNonVisibleAnnotations()
    }
    
    func createAnnotation(forBusinesses business: Businesses) -> CustomAnnotation {
        
        let businessName = business.name
        let location = business.coordinates
        
        let latitude = location.latitude
        let longitude = location.longitude
        
        let annotation = CustomAnnotation(name: businessName, latitude: latitude, longitude: longitude)
        
        return annotation
    }
}

//MARK: - MapView Delegate Methods
extension BusinessesMapViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotation = annotation as? CustomAnnotation
        let smallSquare = CGSize(width: 30.0, height: 30.0)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        let organixPin = #imageLiteral(resourceName: "tempMapPin")
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation?.identifier)
        
        button.setBackgroundImage( #imageLiteral(resourceName: "carIcon"), for: .normal)
        
        annotationView.canShowCallout = true
        annotationView.leftCalloutAccessoryView = button
        annotationView.image = organixPin
        
        return annotationView
    }
}

//MARK: - Gets Directions
extension BusinessesMapViewController {
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let appleMapsLaunchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        if let businessAnnotation = view.annotation {
            
            let businessName: String = (businessAnnotation.title ?? nil) ?? "Unknown"
            
            if let business = findBusiness(withName: businessName, andLocation: businessAnnotation.coordinate) {
                // Make note that user tapped on store
            }
            
            getDrivingDirections(to: businessAnnotation.coordinate, with: businessName).openInMaps(launchOptions: appleMapsLaunchOptions)
        }
    }
    
    func getDrivingDirections(to businessCoordinates: CLLocationCoordinate2D, with businessName: String) -> MKMapItem {
        
        let businessPlacemark = MKPlacemark(coordinate: businessCoordinates, addressDictionary: [ "\(title ?? "")" : businessName])
        let businessPin = MKMapItem(placemark: businessPlacemark)
        
        return businessPin
    }
    
    private func findBusiness(withName name: String, andLocation location: CLLocationCoordinate2D) -> Businesses? {
        
        return businesses.filter({ $0.name == name && $0.coordinates.latitude == location.latitude && $0.coordinates.longitude == location.longitude })
            .first
    }
}

//MARK: - MapView Region Changes
extension BusinessesMapViewController {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapView.centerCoordinate
        self.currentCoordinate = center
        
        self.loadBusinessesAtCoordinate(coordinate: center)
    }
}

//MARK: - Remove Annotations
extension MKMapView {
    
    func isVisible(annotation: MKAnnotation) -> Bool {
        
        let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
        return MKMapRectContainsPoint(self.visibleMapRect, annotationPoint)
    }
    
    func removeNonVisibleAnnotations() {
        
        self.annotations
            .filter({ !isVisible(annotation: $0) })
            .forEach({ self.removeAnnotation($0) })
    }
    
    func removeVisibleAnnotations() {
        
        self.annotations
            .filter({ isVisible(annotation: $0) })
            .forEach({ self.removeAnnotation($0) })
    }
}

//Aroma Messages









