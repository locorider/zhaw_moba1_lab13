//
//  Address.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import CoreData

@objc(Address)
class Address: NSManagedObject {
    @NSManaged var city: String?
    @NSManaged var street: String?
    @NSManaged var country: String?
    @NSManaged var postcode: String?
    @NSManaged var housenumber: String?
}
