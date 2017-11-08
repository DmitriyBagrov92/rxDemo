//
//  PasswordCellViewModel.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 22/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordCellViewModel: ViewModelProtocol {
    
    // MARK: Public Properties - Output
    
    let passwordServiceName: Driver<String>
    
    let passwordValue: Driver<String>
    
    // MARK: Private Properties
    
    private let password: PasswordItem
    
    init(password: PasswordItem) {
        self.password = password
        
        self.passwordServiceName = Observable.just(password.service).asDriver(onErrorJustReturn: NSLocalizedString("Error", comment: ""))
        
        self.passwordValue = Observable.just(password.password).asDriver(onErrorJustReturn: NSLocalizedString("Error", comment: ""))
    }
    
}
