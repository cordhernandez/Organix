//
//  SearchBusinesses.swift
//  Organix
//
//  Created by Cordero Hernandez on 11/1/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Archeota
import CoreLocation
import Foundation

class SearchBusinesses {
    
    typealias Callback = ([Businesses]) -> ()
    
    static func searchForBusinessesLocations(near point: CLLocationCoordinate2D, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood&latitude=\(point.latitude)&longitude=\(point.longitude)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByZipCode(withZipCode zipCode: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood&location=\(zipCode)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByCity(withCity city: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=Vegan&location=\(city)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByName(withName name: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood%26\(name)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByPrice(withPrice price: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood&price=\(price)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByRating(withRating rating: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood&sort_by=\(rating)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func searchForBusinessesByAvailability(withAvailability availability: String, callback: @escaping Callback) {
        
        let businessesAPI = "https://api.yelp.com/v3/businesses/search?term=VeganFood%26VegetarianFood&open_now=\(availability)"
        
        guard let url = URL(string: businessesAPI) else {
            callback([])
            return
        }
        
        getStoresFrom(url: url, callback: callback)
    }
    
    static func getStoresFrom(url: URL, callback: @escaping Callback) {
        
        var request = URLRequest(url: url)
        request.setValue("Bearer 43Zg9cxpeaPbpHAzM3XzzgR_GuS5EuvAlxkV0gnfq8cg2QlzLVpXwx2BSnCqqY2tfLa_Sjg5bOcze9tYUxnhaRlzywJTlXvWDAqZpyaZfJQmqUUzVJdnjupwRikRWXYx", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                
                LOG.error("Failed to download businesses from: \(url), \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                
                LOG.error("Failed to download businesses from: \(url), \(String(describing: error))")
                return
            }
            
            let businesses: [Businesses] = parseStores(from: data)
            callback(businesses)
        }
        
        task.resume()
    }
    
    private static func parseStores(from data: Data) -> [Businesses] {
        
        var businessesArray: [Businesses] = []
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
            return businessesArray
        }
        
        guard let jsonArray = jsonObject?["businesses"] as? NSArray else {
            return businessesArray
        }
        
        for element in jsonArray {
            
            guard let object = element as? NSDictionary else {
                continue
            }
            
            guard let businesses = Businesses.getBusinessesJsonData(from: object) else {
                continue
            }
            
            businessesArray.append(businesses)
        }
        
        return businessesArray
    }
}


