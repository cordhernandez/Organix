//
//  BusinessesModel.swift
//  Organix
//
//  Created by Cordero Hernandez on 10/31/17.
//  Copyright © 2017 Cordero Hernandez. All rights reserved.
//

import Archeota
import Foundation

struct Businesses {
    
    let rating: Double 
    let price: String
    let phone: String
    let id: String
    let isClosed: Bool
//    let categories: [Categories]
    let reviewCount: Int
    let name: String
    let url: String
    let coordinates: Coordinates
    let imageURL: URL
    let location: Location
    let distance: Double
//    let transactions: [String]
    
    static func getBusinessesJsonData(from dictionary: NSDictionary) -> Businesses? {
        
        return Businesses(from: dictionary)
    }
}

extension Businesses {
    
    init?(from businessesDictionary: NSDictionary) {
        
        guard let rating = businessesDictionary["rating"] as? Double,
            let price = businessesDictionary["price"] as? String,
            let phone = businessesDictionary["phone"] as? String,
            let id = businessesDictionary["id"] as? String,
            let isClosed = businessesDictionary["is_closed"] as? Bool,
//            let categoriesJSON = businessesDictionary["categories"] as? NSDictionary,
            let reviewCount = businessesDictionary["review_count"] as? Int,
            let name = businessesDictionary["name"] as? String,
            let url = businessesDictionary["url"] as? String,
            let coordinatesJSON = businessesDictionary["coordinates"] as? NSDictionary,
            let imageStringURL = businessesDictionary["image_url"] as? String,
            let imageURL = URL(string: imageStringURL),
            let locationJSON = businessesDictionary["location"] as? NSDictionary,
            let distance = businessesDictionary["distance"] as? Double
//            let transactions = businessesDictionary["transactions"] as? String
            else {
                
                LOG.error("Failed to parse JSON from businessesDictionary: \(businessesDictionary)")
                return nil
        }
        /*
        guard let categories = Categories(from: categoriesJSON) else {
            
            LOG.error("Failed to parse JSON from Categories: \(categoriesJSON)")
            return nil
        }
        */
        guard let coordinates = Coordinates(from: coordinatesJSON) else {
            
            LOG.error("Failed to parse JSON from Coordinates: \(coordinatesJSON)")
            return nil
        }
        
        guard let location = Location(from: locationJSON) else {
            
            LOG.error("Failed to parse JSON from Location: \(locationJSON)")
            return nil
        }
        
        self.rating = rating
        self.price = price
        self.phone = phone
        self.id = id
        self.isClosed = isClosed
//        self.categories = [categories]
        self.reviewCount = reviewCount
        self.name = name
        self.url = url
        self.coordinates = coordinates
        self.imageURL = imageURL
        self.location = location
        self.distance = distance
//        self.transactions = [transactions]
    }
}

struct Categories {
    
    let alias: String
    let title: String
}

extension Categories {
    
    init?(from categoriesDictionary: NSDictionary) {
        
        guard let alias = categoriesDictionary["alias"] as? String,
            let title = categoriesDictionary["title"] as? String
            else {
                
                LOG.error("Failed to parse JSON from categories dictionary: \(categoriesDictionary)")
                return nil
        }
        
        self.alias = alias
        self.title = title
    }
}

struct Coordinates {
    
    let latitude: Double
    let longitude: Double
}

extension Coordinates {
    
    init?(from coordinatesDictionary: NSDictionary) {
        
        guard let latitude = coordinatesDictionary["latitude"] as? Double,
            let longitude = coordinatesDictionary["longitude"] as? Double
            else {
                
                LOG.error("Failed to parse JSON from coordinates dictionary: \(coordinatesDictionary)")
                return  nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct Location {
    
    let city: String
    let country: String
    let state: String
    let address1: String
    let zipCode: String
}

extension Location {
    
    init?(from locationDictionary: NSDictionary) {
        
        guard let city = locationDictionary["city"] as? String,
            let country = locationDictionary["country"] as? String,
            let state = locationDictionary["state"] as? String,
            let address1 = locationDictionary["address1"] as? String,
            let zipCode = locationDictionary["zip_code"] as? String
            else {
                
                LOG.error("Failed to parse JSON from location dictionary: \(locationDictionary)")
                return nil
        }
        
        self.city = city
        self.country = country
        self.state = state
        self.address1 = address1
        self.zipCode = zipCode
    }
}


