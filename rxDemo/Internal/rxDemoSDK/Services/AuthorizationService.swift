//
//  AuthorizationService.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift

class AuthorizationService {
    
    // MARK: Public Properties - Input
    
    let loginObserver: AnyObserver<String?>
    
    // MARK: Public Properties - Output
    
    let login: Observable<String?>
    
    // MARK: Private Properties
    
    private let storage = UserDefaults.standard
    
    private let kUserLoginKey = "kUserLoginKey"
    
    private let disposeBag = DisposeBag()
    
    private let loginSubject: BehaviorSubject<String?>
    
    // MARK: Lyfecircle
    
    init() {
        //TODO: Login temporary save in userdefault to easy test
        self.loginSubject = BehaviorSubject<String?>(value: storage.string(forKey: kUserLoginKey))
        self.loginObserver = loginSubject.asObserver()
        self.login = loginSubject.asObservable()
    }
    
    func prepare() {
        loginSubject.bind(onNext: { [unowned self] (next) in
            if let login = next {
                self.storage.set(login, forKey: self.kUserLoginKey)
                self.storage.synchronize()
                
                demoSDK.networkService.session = AuthorizationSession(token: String(login.hashValue))
            }
        }).disposed(by: disposeBag)
    }
    
}

struct AuthorizationSession: NetworkServiceSession {
    
    // MARK: Constants
    
    let kAuthHeaderKey = "Passwords-User-Token"
    
    // MARK: NetworkServiceSession Properties
    
    var token: String
    
    var httpHeaders: [String : String] {
        return [kAuthHeaderKey : token]
    }
    
    // MARK: Lyfecircle
    
    init(token: String) {
        self.token = token
    }
    
}
