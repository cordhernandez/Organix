//
//  WelcomeScreenFour.swift
//  Organix
//
//  Created by Cordero Hernandez on 1/15/18.
//  Copyright © 2018 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation
import UIKit

class WelcomeScreenFour: UIViewController {
    
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var zipCodeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate var eitherOneSelected: Bool {
        
        return UserPreferences.instance.useMyLocation ||
               UserPreferences.instance.useZipCode
    }
    
    fileprivate var neitherOneSelected: Bool {
        
        return !UserPreferences.instance.useMyLocation ||
               !UserPreferences.instance.useZipCode
    }
    
    var delegate: WelcomeScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func dismiss() {
        
        self.delegate?.didDismissWelcomeScreens()
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Location Code
extension WelcomeScreenFour {
    
    var useGPS: Bool {
        
        get {
            return UserPreferences.instance.useMyLocation
        }
        
        set(newValue) {
            UserPreferences.instance.useMyLocation = newValue
            UserPreferences.instance.useZipCode = !newValue
            
            if newValue == true {
                //Make Aroma note that user selected GPS
            }
        }
    }
    
    var gpsAuthorized: Bool {
        
        if let status = GlobalLocationManager.instance.currentStatus, status == .authorizedAlways, status == .authorizedWhenInUse {
            return true
        }
        else {
            return false
        }
    }
    
    var useZipCode: Bool {
        
        get {
            return UserPreferences.instance.useZipCode
        }
        
        set(newValue) {
            UserPreferences.instance.useZipCode = newValue
            UserPreferences.instance.useMyLocation = newValue
            
            if newValue == true {
                //Make Aroma note that User selected zip code
            }
        }
    }
    
    var zipCode: String {
        
        get {
            return UserPreferences.instance.zipCode ?? ""
        }
        
        set(newValue) {
            UserPreferences.instance.zipCode = newValue
        }
    }
    
    func requestGPS() {
        
        if let status = GlobalLocationManager.instance.currentStatus, status == .denied {
            
            let alert = self.createAlertToSendUserToLocationSettings()
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        GlobalLocationManager.instance.requestLocation { (location) in
            
            LOG.info("GPS successfully enabled")
            self.useGPS = true
            //self.updateButtons()
        }
    }
    
    func isValidZipCode(_ zipCode: String) -> (isValid: Bool, errorMessage: String) {
        
        if zipCode.isEmpty {
            
            return (false, "Zip Code is Empty")
        }
        
        if zipCode.count != 5 {
            
            return (false, "Zip Code must be 5 digits")
        }
        
        guard let _ = Int(zipCode) else {
            return (false, "Zip Code must be numerical")
        }
        
        return (true, "")
    }
}











