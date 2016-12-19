//
//  PostOfficeStore.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class PostOfficeStore {
    
    //var postOffices: [PostOffice] = []
    let dataController: CoreDataStack
    
    required init() {
        self.dataController = CoreDataStack()
    }
    
    func filter(fromLocation: CLLocation, distance: Double) -> [SearchResult] {
        let filtered = self.postOffices(lat: fromLocation.coordinate.latitude, lon: fromLocation.coordinate.longitude).filter { $0.withinBounds(location: fromLocation, maxDistance: distance) }
        print("\(filtered.count) within \(distance) meters")
        let searchResults = filtered.map { SearchResult(postOffice: $0, distanceMeter: $0.distance(location: fromLocation)) }
        let sorted = searchResults.sorted { (one: SearchResult, two: SearchResult) -> Bool in
            return one.distanceMeter < two.distanceMeter
        }
    
        return sorted
    }
   
    func postOffices(lat: Double, lon: Double) -> [PostOffice] {
        return self.dataController.data(100, lat: lat, lon: lon)
    }
    
    func load(file: String, type: String) {
        let path = Bundle.main.path(forResource: file, ofType: type)
        do {
            let data = try String(contentsOfFile: path!)
            self.parseFileContents(data)
        } catch {
            
        }
    }
    
    func parseFileContents(_ data: String) {
        let lines = data.components(separatedBy: NSCharacterSet.newlines)
        print("Got %d lines", lines.count)
        for line in lines {
            self.parseLine(line)
        }
    }
    
    func parseLine(_ line: String) {
        print("Parsing %s", line)
        let components = line.components(separatedBy: ",")
        if 2 < components.count {
            let latitude = Double(components[0])
            let longitude = Double(components[1])
            // let location = CLLocation(latitude: latitude!, longitude: longitude!)
            let postOffice = PostOffice(context: self.dataController.persistentContainer.viewContext)
            postOffice.lat = NSNumber(value: latitude!)
            postOffice.lon = NSNumber(value: longitude!)
            
            let withoutCoordinates = components[2..<components.count]
            self.parseInfoComponents(postOffice, lineWithoutCoordinates: withoutCoordinates)
            
            //postOffices.append(postOffice)
            
            self.dataController.saveContext()
        } else {
            print("Line has no the required amount of information")
        }
    }
    
    func parseInfoComponents(_ postOffice: PostOffice, lineWithoutCoordinates: ArraySlice<String>) {
        for info in lineWithoutCoordinates {
            let infoComponents = info.components(separatedBy: "=")
            if 2 == infoComponents.count {
                let type = infoComponents[0]
                let value = infoComponents[1]
                
                let address = Address(context: self.dataController.persistentContainer.viewContext)
                let contact = Contact(context: self.dataController.persistentContainer.viewContext)
                
                switch type {
                case "name": postOffice.name = value
                    break
                case "brand": postOffice.brand = value
                    break
                case "amenity": postOffice.amenity = value
                    break
                case "website": postOffice.website = value
                    break
                case "alt_name": postOffice.altName = value
                    break
                case "operator": postOffice.operatorName = value
                    break
                case "addr:city": address.city = value
                    break
                case "addr:street": address.street = value
                    break
                case "addr:country": address.country = value
                    break
                case "addr:housenumber": address.housenumber = value
                    break
                case "addr:postcode": address.postcode = value
                    break
                case "contact:fax": contact.fax = value
                    break
                case "email": contact.email = value
                    break
                case "contact:email": contact.email = value
                    break
                case "contact:phone": contact.phone = value
                    break
                case "opening_hours": postOffice.openingHours = value
                    break
                case "wheelchair": postOffice.wheelChair = NSNumber(value: value.lowercased() == "yes")
                    break
                default: break
                }
                
                postOffice.address = address
                postOffice.contact = contact
            }
        }
    }
}
