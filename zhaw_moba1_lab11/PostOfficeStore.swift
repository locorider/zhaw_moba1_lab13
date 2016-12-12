//
//  PostOfficeStore.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import CoreLocation

class PostOfficeStore {
    
    var postOffices: [PostOffice] = []
    
    func filter(fromLocation: CLLocation, distance: Double) -> [SearchResult] {
        let filtered = self.postOffices.filter { $0.withinBounds(location: fromLocation, maxDistance: distance) }
        print("\(filtered.count) within \(distance) meters")
        let searchResults = filtered.map { SearchResult(postOffice: $0, distanceMeter: $0.distance(location: fromLocation)) }
        let sorted = searchResults.sorted { (one: SearchResult, two: SearchResult) -> Bool in
            return one.distanceMeter < two.distanceMeter
        }
    
        return sorted
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
            let location = CLLocation(latitude: latitude!, longitude: longitude!)
            let postOffice = PostOffice(location: location)
            
            let withoutCoordinates = components[2..<components.count]
            self.parseInfoComponents(postOffice, lineWithoutCoordinates: withoutCoordinates)
            
            postOffices.append(postOffice)
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
                case "addr:city": postOffice.address.city = value
                    break
                case "addr:street": postOffice.address.street = value
                    break
                case "addr:country": postOffice.address.country = value
                    break
                case "addr:housenumber": postOffice.address.housenumber = value
                    break
                case "addr:postcode": postOffice.address.postcode = value
                    break
                case "contact:fax": postOffice.contact.fax = value
                    break
                case "email": postOffice.contact.email = value
                    break
                case "contact:email": postOffice.contact.email = value
                    break
                case "contact:phone": postOffice.contact.phone = value
                    break
                case "opening_hours": postOffice.openingHours = value
                    break
                case "wheelchair": postOffice.wheelChair = value.lowercased() == "yes"
                    break
                default: break
                }
            }
        }
    }
}
