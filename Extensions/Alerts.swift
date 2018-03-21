//
//  Alerts.swift
//  Organix
//
//  Created by Cordero Hernandez on 1/20/18.
//  Copyright © 2018 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation
import UIKit

extension UIViewController {
    
    func showAlertWithError(message: String) {
        
        showAlert(title: "Error", message: message)
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(ok)
        presentAlert(alert)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Sender User to Settings
    func createAlertToSendUserToLocationSettings() -> UIAlertController {
        
        let title = "Requesting GPS Access"
        let message = "Please go to \"Location\" and enable \"While Using the App\""
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let openSettings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            self.sendUserToSettings()
        }
        
        controller.addAction(openSettings)
        
        return controller
        
    }
    
    func sendUserToSettings() {
        
        let link = UIApplicationOpenSettingsURLString
        
        guard let url = URL(string: link) else {
            LOG.error("Failed to create URL to \(link)")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

//MARK: - WelcomeScreenFour Alert View
extension WelcomeScreenFour {
    
    //GPS
    func createAlertToRequestGPS() -> UIAlertController {
        
        let title = "Enable GPS"
        let message = "GPS is used to find Vegan and Vegetarian restaurants around you, and only while you are in the app"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            
            self.requestGPS()
        }
        
        alert.addActions(ok, cancel)
        
        return alert
    }
    
    //Zip Code
    func createAlertToRequestZipCode() -> UIAlertController {
        
        let title = "Enter Zip Code"
        let message = "Enter 5-digit zip to find Vegan and Vegetarian restaurants in that area"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = createZipCodeOkButton(for: alert)
        
        alert.addActions(cancel, ok)
        
        alert.addTextField { (textField) in
            
            textField.keyboardType = .numberPad
            textField.becomeFirstResponder()
        }
        
        return alert
    }
    
    func createZipCodeOkButton(for alert: UIAlertController) -> UIAlertAction {
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let zipCode = alert.textFields?.first?.text, zipCode.isNotEmpty else {
                self.showAlertWithError(message: "Zip Code cannot be empty")
                return
            }
            
            let valid = self.isValidZipCode(zipCode)
            
            guard valid.isValid else {
                
                let message = valid.errorMessage
                
                LOG.warn("Invalid Zip Code: \(message)")
                self.showAlertWithError(message: message)
                
                return
            }
            
            self.useZipCode = true
            self.zipCode = zipCode
            self.updateButtons()
        }
        
        return ok
    }
    
    //City
    func createAlertToRequestCity() -> UIAlertController {
        
        let title = "Enter a City"
        let message = "Enter a city to find Vegan and Vegetarian restaurants in that city"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let ok = createCityOkButton(for: alert)
        
        alert.addActions(cancel, ok)
        
        alert.addTextField { (textField) in
            
            textField.keyboardType = .alphabet
            textField.becomeFirstResponder()
        }
        
        return alert
    }
    
    func createCityOkButton(for alert: UIAlertController) -> UIAlertAction {
        
        let ok = UIAlertAction(title: "OK", style: .default) {_ in
            
            guard let city = alert.textFields?.first?.text, city.isNotEmpty else {
                self.showAlertWithError(message: "City cannot be empty")
                return
            }
            
            let valid = self.isValidCity(city)
            
            guard valid.isValid else {
                
                let message = valid.errorMessage
                
                LOG.warn("Invalid city: \(message)")
                self.showAlertWithError(message: message)
                
                return
            }
            
            self.useCity = true
            self.city = city
            self.updateButtons()
        }
        
        return ok
    }
}

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        
        actions.forEach(self.addAction)
    }
}

//MARK: - Aroma Messages
fileprivate extension UIViewController {
    
    //func makeNoteThatSendingUserToSettings()
}
