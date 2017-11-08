//
//  SwiftFuncExtension.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

func + <K,V>(left: [K : V], right: [K : V]) -> [K : V] {
    var result = [K:V]()
    
    for (key,value) in left {
        result[key] = value
    }
    
    for (key,value) in right {
        result[key] = value
    }
    return result
}
