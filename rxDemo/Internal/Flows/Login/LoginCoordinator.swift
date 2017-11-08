//
//  LoginCoordinator.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class LoginCoordinator: CoordinatorProtocol {
    
    // MARK: Public Properties
    
    lazy var loginViewModel = LoginViewModel()
    
    var loginViewController: LoginViewController?
    
    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: CoordinatorProtocol Methods
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        let nvc = UIStoryboard(name: LoginViewController.identifier, bundle: nil).instantiateInitialViewController() as? UINavigationController
        loginViewController = nvc?.topViewController as? LoginViewController
        loginViewController?.viewModel = loginViewModel
        
        viewController.present(nvc!, animated: true, completion: nil)
        
        loginViewModel.doneAction.drive(onNext: { [unowned self] () in
            self.loginViewController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
