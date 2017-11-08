//
//  AppCoordinator.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    // MARK: Public Properties
    
    lazy var loginCoordinator = LoginCoordinator()
    
    lazy var passwordListCoordinator = PasswordsListCoordinator()
    
    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: CoordinatorProtocol Methods
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        viewController.rx.viewDidAppear.bind(onNext: { [unowned self] () in
            demoSDK.authService.login.bind(onNext: { (login) in
                if let _ = login {
                    self.coordinate(to: self.passwordListCoordinator, from: viewController)
                } else {
                    self.coordinate(to: self.loginCoordinator, from: viewController)
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
