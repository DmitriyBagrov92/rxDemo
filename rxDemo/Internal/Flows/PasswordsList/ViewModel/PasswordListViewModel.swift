//
//  PasswordListViewModel.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordsListViewModel: ViewModelProtocol {
    
    // MARK: Public Properties - Inputs
    
    let newPasswordObserver: AnyObserver<Void>
    
    let passwordsRefreshObserver: AnyObserver<Void>
    
    // MARK: Public Properties - Outputs
    
    let newPasswordAction: Driver<Void>
    
    let passwordRefreshActivity: Driver<Bool>
    
    let passwords: Observable<[PasswordCellViewModel]>
    
    // MARK: Lyfecircle
    
    init() {
        let _newPasswordAction = PublishSubject<Void>()
        self.newPasswordObserver = _newPasswordAction.asObserver()
        self.newPasswordAction = _newPasswordAction.asDriver(onErrorJustReturn: ())
        
        let _passwordsRefreshObserver = PublishSubject<Void>()
        self.passwordsRefreshObserver = _passwordsRefreshObserver.asObserver()
        
        let passwordsRequest = Observable.merge(Observable.just(), _passwordsRefreshObserver.asObservable()).flatMap({ demoSDK.passwordService.list() }).share()
        
        self.passwordRefreshActivity = Observable.merge(Observable.just(true), passwordsRequest.map({ _ in return false })).asDriver(onErrorJustReturn: false)
        
        self.passwords = passwordsRequest.map({ $0.map({ PasswordCellViewModel(password: $0) })})
    }
}
