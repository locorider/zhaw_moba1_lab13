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

@objc(PostOffice)
class PostOffice: NSManagedObject {
    @NSManaged var lat: NSNumber?
    @NSManaged var lon: NSNumber?
    @NSManaged var name: String?
    @NSManaged var brand: String?
    @NSManaged var amenity: String?
    @NSManaged var website: String?
    @NSManaged var altName: String?
    @NSManaged var operatorName: String?
    @NSManaged var address: Address?
    @NSManaged var contact: Contact?
    @NSManaged var openingHours: String?
    @NSManaged var wheelChair: NSNumber?
    
    func distance(location: CLLocation) -> Double {
        return self.location().distance(from: location)
    }
    
    func location() -> CLLocation {
        return CLLocation(latitude: (lat?.doubleValue)!, longitude: (lon?.doubleValue)!)
    }
    
    func withinBounds(location: CLLocation, maxDistance: Double) -> Bool {
        let distance = self.location().distance(from: location)
        //print("Distance: \(distance), maxDistance: \(maxDistance)")
        return distance <= maxDistance
    }
}
