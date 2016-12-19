//
//  PostOffice.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class PostOffice {
    var lat: Double = 0.0
    var lon: Double = 0.0
    var name: String?
    var brand: String?
    var amenity: String?
    var website: String?
    var altName: String?
    var operatorName: String?
    var address = Address()
    var contact = Contact()
    var openingHours: String?
    var wheelChair = false
    
    func distance(location: CLLocation) -> Double {
        return self.location().distance(from: location)
    }
    
    func location() -> CLLocation {
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    func withinBounds(location: CLLocation, maxDistance: Double) -> Bool {
        let distance = self.location().distance(from: location)
        //print("Distance: \(distance), maxDistance: \(maxDistance)")
        return distance <= maxDistance
    }
}
