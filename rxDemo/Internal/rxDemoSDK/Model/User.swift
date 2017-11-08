//
//  User.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

class User {
    
    // MARK: Public Properties
    
    var login: String? {
        set {
            store.set(newValue, forKey: kLoginKey)
            store.synchronize()
        }
        get {
            return store.string(forKey: kLoginKey)
        }
    }
    
    var isAuthorized: Bool {
        return login != nil
    }
    
    // MARK: Private Properties
    
    private let store = UserDefaults.standard

    private let kLoginKey = "kLoginKey"
}
