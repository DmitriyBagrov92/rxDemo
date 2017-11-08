//
//  rxDSDK.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation

//let demoSDK.networkService = NetworkService(configuration: NetworkServiceConfiguration(baseUrl: kBasePasswordsUrl))

//let demoSDK.authService = AuthorizationService()

//let demoSDK.passwordService = PasswordService()

let demoSDK = rxSDK()

struct rxSDK {
    
    let networkService: NetworkService
    
    let authService: AuthorizationService
    
    let passwordService: PasswordService
    
    init() {
        self.networkService = NetworkService(configuration: NetworkServiceConfiguration(baseUrl: kBasePasswordsUrl))
        self.authService = AuthorizationService()
        self.passwordService = PasswordService()
    }
    
    func prepare() {
        authService.prepare()
    }
    
}
