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
    @IBOutlet weak var cityButton: UIButton!
    
    fileprivate var originalZipCodeText: NSAttributedString!
    fileprivate var originzalCityText: NSAttributedString!
    
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
        
        //Make Aroma message that Screen Launched
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let zipCodeTitle = self.zipCodeButton.attributedTitle(for: .normal) {
            self.originalZipCodeText = zipCodeTitle
        }
        
        if let cityTitle = self.cityButton.attributedTitle(for: .normal) {
            self.originzalCityText = cityTitle
        }
        
        updateButtons(animated: false)
    }
    
    fileprivate func dismiss() {
        
        self.delegate?.didDismissWelcomeScreens()
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - IBActions
extension WelcomeScreenFour {
    
    @IBAction func didSelectMyLocationButton(_ sender: Any) {
        
        let alert = createAlertToRequestGPS()
        presentAlert(alert)
        //Make Aroma message that user tapped on GPS
    }
    
    @IBAction func didSelectZipCodeButton(_ sender: Any) {
        
        let alert = createAlertToRequestZipCode()
        presentAlert(alert)
        //Make Aroma message that user tapped on Zip Code
    }
    
    @IBAction func didSelectCityButton(_ sender: Any) {
        
        let alert = createAlertToRequestCity()
        presentAlert(alert)
        //Make Aroma message that user tapped on Zip Code
    }
    
    @IBAction func didSelectNextButton(_ sender: Any) {
        
        self.dismiss()
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
            UserPreferences.instance.useCity = !newValue
            
            if newValue == true {
                //Make Aroma message that user selected GPS
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
            UserPreferences.instance.useMyLocation = !newValue
            UserPreferences.instance.useCity = !newValue
            
            if newValue == true {
                //Make Aroma message that user selected zip code
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
    
    var useCity: Bool {
        
        get {
            return UserPreferences.instance.useCity
        }
        
        set(newValue) {
            UserPreferences.instance.useCity = newValue
            UserPreferences.instance.useMyLocation = !newValue
            UserPreferences.instance.useZipCode = !newValue
            
            if newValue == true {
                //Make Aroma message that user selected city
            }
        }
    }
    
    var city: String {
        
        get {
            return UserPreferences.instance.city ?? ""
        }
        
        set(newValue) {
            UserPreferences.instance.city = newValue
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
            self.updateButtons()
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
    
    func isValidCity(_ city: String) -> (isValid: Bool, errorMessage: String) {
        
        if city.isEmpty {
            return (false, "City is empty")
        }
        
        if city.count > 30 {
            return (false, "City text is too long")
        }
        
        return (true, "")
    }
}

//MARK: - UI Setup & Style Menu
extension WelcomeScreenFour {
    
    func updateButtons(animated: Bool = true) {
        
        if useGPS && gpsAuthorized {
            
            selectMyLocationButton(animated: animated)
            enableNextButton()
        }
        else if useZipCode {
            
            selectZipCodeButton(animated: animated)
            enableNextButton()
        }
        else if useCity {
            
            selectCityButton(animated: animated)
            enableNextButton()
        }
        else {
            
            disableNextButton()
        }
    }
    
    //Select Buttons
    func selectMyLocationButton(animated: Bool = true) {
        
        uncloakMyLocationButton()
        disableMyLocationButton()
        
        cloakZipCodeButton()
        enableZipCodeButton()
        updateZipCodeText()
        
        cloakCityButton()
        enableCityButton()
        updateCityText()
    }
    
    func selectZipCodeButton(animated: Bool = true) {
        
        uncloakZipCodeButton()
        disableZipCodeButton()
        updateZipCodeText()
        
        cloakMyLocationButton()
        enableMyLocationButton()
        
        cloakCityButton()
        enableCityButton()
        updateCityText()
    }
    
    func selectCityButton(animated: Bool = true) {
        
        uncloakCityButton()
        disableCityButton()
        updateCityText()
        
        cloakMyLocationButton()
        enableMyLocationButton()
        
        cloakZipCodeButton()
        enableZipCodeButton()
        updateZipCodeText()
    }
    
    //Update Text
    func updateZipCodeText() {
        
        if useZipCode {
            
            let text = NSMutableAttributedString(string: zipCode, attributes: originalZipCodeText.attributes(at: 0, effectiveRange: nil))
            
            if let font = UIFont(name: "Avenir Next Medium", size: 16) {
                
                text.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange.init(location: 0, length: text.string.count))
                zipCodeButton.setAttributedTitle(text, for: .normal)
            }
        }
        else {
            zipCodeButton.setAttributedTitle(originalZipCodeText, for: .normal)
        }
    }
    
    func updateCityText() {
        
        if useCity {
            
            let text = NSMutableAttributedString(string: city, attributes: originzalCityText.attributes(at: 0, effectiveRange: nil))
            
            if let font = UIFont(name: "Avenir Next Medium", size: 16) {
                
                text.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange.init(location: 0, length: text.string.count))
                cityButton.setAttributedTitle(text, for: .normal)
            }
        }
        else {
            cityButton.setAttributedTitle(originzalCityText, for: .normal)
        }
    }
    
    //My Location Button
    func enableMyLocationButton() {
        
        myLocationButton.isEnabled = true
    }
    
    func disableMyLocationButton() {
        
        myLocationButton.isEnabled = false
    }
    
    func cloakMyLocationButton() {
        
        myLocationButton.alpha = 0.6
    }
    
    func uncloakMyLocationButton() {
        
        myLocationButton.alpha = 1.0
    }
    
    //Zip Code Button
    func enableZipCodeButton() {
        
        zipCodeButton.isEnabled = true
    }
    
    func disableZipCodeButton() {
        
        zipCodeButton.isEnabled = false
    }
    
    func cloakZipCodeButton() {
        
        zipCodeButton.alpha = 0.6
    }
    
    func uncloakZipCodeButton() {
        
        zipCodeButton.alpha = 1.0
    }
    
    //City Button
    func enableCityButton() {
        
        cityButton.isEnabled = true
    }
    
    func disableCityButton() {
        
        cityButton.isEnabled = false
    }
    
    func cloakCityButton() {
        
        cityButton.alpha = 0.6
    }
    
    func uncloakCityButton() {
        
        cityButton.alpha = 1.0
    }
    
    //Next Button
    func enableNextButton() {
        
        let animations = {
            
            self.nextButton.isEnabled = true
            self.nextButton.alpha = 1.0
        }
        
        animate(withView: nextButton, animations: animations)
    }
    
    func disableNextButton() {
        
        let animations = {
            
            self.nextButton.isEnabled = false
            self.nextButton.alpha = 0.6
        }
        
        animate(withView: nextButton, animations: animations)
    }
    
    //Animations
    func styleButtonOn(button: UIButton) {
        
        let animations = {
            
            button.backgroundColor = UIColor(red: 77.0, green: 150.0, blue: 156.0, alpha: 1.0)
        }
        
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
    
    func styleButtonOff(button: UIButton) {
        
        let animations = {
            
            button.backgroundColor = UIColor(red: 77.0, green: 150.0, blue: 156.0, alpha: 1.0)
        }
        
        UIView.transition(with: button, duration: 0.4, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
    
    func animate(withView view: UIView, animations: @escaping () -> ()) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .transitionCrossDissolve, animations: animations, completion: nil)
    }
}

