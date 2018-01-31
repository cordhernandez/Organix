//
//  UserPreferences.swift
//  Organix
//
//  Created by Cordero Hernandez on 12/16/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Foundation

class UserPreferences {
    
    static let instance = UserPreferences()
    private init() {}
    
    let defaultPreferences = UserDefaults.standard
    
    var distanceFilter: Double {
        
        get {
            return defaultPreferences.double(forKey: Keys.searchRadius)
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.searchRadius)
        }
    }
    
    var showVeganBusinesses: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.showVeganBusinesses) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.showVeganBusinesses)
        }
    }
    
    var showVegetarianBusinesses: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.showVegetarianBusinesses) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.showVegetarianBusinesses)
        }
    }
    
    var useMyLocation: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.useMyLocation) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.useMyLocation)
        }
    }
    
    var useZipCode: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.useZipCode) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.useZipCode)
        }
    }
    
    var useCity: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.useCity) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.useCity)
        }
    }
    
    var zipCode: String? {
        
        get {
            return defaultPreferences.object(forKey: Keys.zipCode) as? String
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.zipCode)
        }
    }
    
    var city: String? {
        
        get {
            return defaultPreferences.object(forKey: Keys.city) as? String
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.city)
        }
    }
    
    var isFirstTimeUser: Bool {
        
        get {
            return defaultPreferences.object(forKey: Keys.isFirstTimeUser) as? Bool ?? false
        }
        
        set (value) {
            defaultPreferences.set(value, forKey: Keys.isFirstTimeUser)
        }
    }
}

fileprivate class Keys {
    
    static let searchRadius = "searchRadius"
    static let showVeganBusinesses = "showVeganBusinesses"
    static let showVegetarianBusinesses = "showVegetarianBusinesses"
    static let useMyLocation = "useMyLocation"
    static let useZipCode = "useZipCode"
    static let useCity = "useCity"
    static let zipCode = "zipCode"
    static let city = "city"
    static let isFirstTimeUser = "isFirstTimeUser"
}

