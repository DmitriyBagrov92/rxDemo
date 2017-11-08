//
//  PasswordItem.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

struct PasswordItem: Codable {
    
    // MARK: Public Properties
    
    var id: Int
    
    var service: String
    
    var password: String
    
}
