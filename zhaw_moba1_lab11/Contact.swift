//
//  Contact.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 04.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation
import CoreData

@objc(Contact)
class Contact: NSManagedObject {
    @NSManaged var fax: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
}
