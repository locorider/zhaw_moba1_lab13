//
//  DBManager.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 19.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostOffice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                //fatalError("Unresolved error \(error), \(error.)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func data(_ limit: Int, lat: Double, lon: Double) -> [PostOffice] {
        let request = NSFetchRequest<PostOffice>(entityName: "PostOffice")
        let minLat = lat - 0.5
        let maxLat = lat + 0.5
        let minLon = lon - 0.5
        let maxLon = lon + 0.5
        request.fetchLimit = limit
        request.predicate = NSPredicate(format: "lat <= %f AND lat >= %f AND lon <= %f AND lon >= %f", maxLat, minLat, maxLon, minLon)
        request.relationshipKeyPathsForPrefetching = ["address", "contact"]
        
        do {
            
            let offices = try persistentContainer.viewContext.fetch(request)
            return offices
        } catch {
            fatalError("Failed to fetch post offices \(error)")
        }
        
        return []
    }
}
