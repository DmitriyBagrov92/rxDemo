//
//  NetworkServiceConfiguration.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

class NetworkServiceConfiguration {
    
    // MARK: Public Properties
    
    let baseUrl: URL
    
    let httpHeaders: [String: String]
    
    var isDebugEnabled = true
    
    var isNetworkActivityIndicatorVisible = true
    
    // MARK: Lyfecircle
    
    init(baseUrl: URL, httpHeaders: [String: String] = [:]) {
        self.baseUrl = baseUrl
        self.httpHeaders = httpHeaders
    }
    
}
