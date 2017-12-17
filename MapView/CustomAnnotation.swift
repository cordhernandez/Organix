//
//  CustomAnnotation.swift
//  Organix
//
//  Created by Cordero Hernandez on 12/16/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var identifier = "business location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        title = name
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
}
