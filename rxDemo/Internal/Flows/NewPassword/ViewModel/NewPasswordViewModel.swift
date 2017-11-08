//
//  NewPasswordViewModel.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NewPasswordViewModelError: Error {
    case missedPasswordOrServiceName
}

class NewPasswordViewModel: ViewModelProtocol {
    
    // MARK: Constants
    
    private let kDefaultPasswordLength = 5
    
    // MARK: Public Properties (Input)
    
    let serviceNameObserver: AnyObserver<String?>
    
    let generateActionObserver: AnyObserver<Void>
    
    let passwordLengthObserver: AnyObserver<Int>
    
    let doneActionObserver: AnyObserver<Void>
    
    // MARK: Public Properties (Output)
    
    let isGenerateButtonEnabled: Driver<Bool>
    
    let passwordLengthString: Driver<String>
    
    let passwordString: Driver<String>
    
    let isDoneActionButtonEnabled: Driver<Bool>
    
    let passwordCreationActivityHidden: Driver<Bool>
    
    let viewDismiss: Driver<Void>
    
    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lyfecircle
    
    init() {
        let _serviceNameObserver = BehaviorSubject<String?>(value: nil)
        self.serviceNameObserver = _serviceNameObserver.asObserver()
        
        let _generateActionObserver = PublishSubject<Void>()
        self.generateActionObserver = _generateActionObserver.asObserver()
        
        let _passwordLengthSubject = BehaviorSubject<Int>(value: kDefaultPasswordLength)
        self.passwordLengthObserver = _passwordLengthSubject.asObserver()
        
        let _doneActionObserver = PublishSubject<Void>()
        self.doneActionObserver = _doneActionObserver.asObserver()
        
        let _isGenerateButtonEnabled = _serviceNameObserver.map({ $0?.count != 0 })
        self.isGenerateButtonEnabled = _isGenerateButtonEnabled.asDriver(onErrorJustReturn: false)
        
        self.passwordLengthString = _passwordLengthSubject.map({ String($0) }).asDriver(onErrorJustReturn: "Error")
        
        let _password = _generateActionObserver.withLatestFrom(_passwordLengthSubject).map({ String.random(with: $0) }).share()
        self.passwordString = _password.asDriver(onErrorJustReturn: "Error")
        
        let _isDoneActionButtonEnabled = Observable.combineLatest(_isGenerateButtonEnabled, _password).map { (isServicePresent, password) -> Bool in
            return isServicePresent && password.count != 0
        }.startWith(false)
        self.isDoneActionButtonEnabled = _isDoneActionButtonEnabled.asDriver(onErrorJustReturn: false)
        
        let _passwordCreationActivityHidden = BehaviorSubject<Bool>(value: true)
        self.passwordCreationActivityHidden = _passwordCreationActivityHidden.asDriver(onErrorJustReturn: true)
        
        let passwordInfo = Observable.combineLatest(_serviceNameObserver, _password)

        let passwordCreationRequest = _doneActionObserver.withLatestFrom(passwordInfo).flatMap({ (service, password) -> Observable<Void> in
            _passwordCreationActivityHidden.onNext(false)
            return demoSDK.passwordService.create(new: password, for: service!)
        }).share()
        
        passwordCreationRequest.map({ _ in return true }).bind(to: _passwordCreationActivityHidden).disposed(by: disposeBag)
        
        self.viewDismiss = passwordCreationRequest.asDriver(onErrorJustReturn: ())
    }
    
}
