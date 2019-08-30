//
//  User.swift
//  ArkusnexusTest
//
//  Created by Rogelio Contreras Velázquez on 29/08/19.
//  Copyright © 2019 Rogelio Contreras Velázquez. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject {
    
    static let shared  = User()
    var location : CLLocationCoordinate2D?
    
    override init() {
        
    }
    
}
