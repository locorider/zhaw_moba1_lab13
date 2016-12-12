//
//  SearchResult.swift
//  zhaw_moba1_lab11
//
//  Created by José Miguel Rota on 05.12.16.
//  Copyright © 2016 José Miguel Rota. All rights reserved.
//

import Foundation


class SearchResult {
    
    let postOffice: PostOffice
    let distanceMeter: Double
    
    required init(postOffice: PostOffice, distanceMeter: Double) {
        self.postOffice = postOffice
        self.distanceMeter = distanceMeter
    }
}
