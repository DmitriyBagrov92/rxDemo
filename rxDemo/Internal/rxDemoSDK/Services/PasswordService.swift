//
//  PasswordService.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift

class PasswordService {
    
    // MARK: Public Methods
    
    func create(new password: String, for service: String) -> Observable<Void> {
        return demoSDK.networkService.request(method: .post, endpoint: kItemUrl, bodyParameters: ["service" : service, "password" : password])
    }
    
    func list() -> Observable<[PasswordItem]> {
        return demoSDK.networkService.request(method: .get, endpoint: kListUrl)
    }
    
}
