//
//  LoginViewModel.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelProtocol {
    
    // MARK: Public Properties - Inputs
    
    let inputUserLogin: AnyObserver<String?>
        
    let doneActionObserver: AnyObserver<Void>
    
    // MARK: Public Properties - Outputs
    
    let isDoneButtonEnabled: Driver<Bool>
    
    let doneAction: Driver<Void>
    
    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lyfecircle
    
    init() {
        let _inputUserLogin = BehaviorSubject<String?>(value: nil)
        inputUserLogin = _inputUserLogin.asObserver()
        
        isDoneButtonEnabled = _inputUserLogin.asObservable().map({ $0?.count != 0 }).asDriver(onErrorJustReturn: false)
        
        let _doneAction = PublishSubject<Void>()
        doneAction = _doneAction.asDriver(onErrorJustReturn: ())
        doneActionObserver = _doneAction.asObserver()
        
        _doneAction.withLatestFrom(_inputUserLogin).bind { (login) in
            demoSDK.authService.loginObserver.onNext(login)
        }.disposed(by: disposeBag)
    }
    
}
