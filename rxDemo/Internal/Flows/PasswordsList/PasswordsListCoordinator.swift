//
//  PasswordsListCoordinator.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PasswordsListCoordinator: CoordinatorProtocol {
    
    // MARK: Public Properties
    
    let passwordsListViewModel = PasswordsListViewModel()

    var passwordsListTableViewController: PasswordsListTableViewController?
    
    // MARK: Child Coordinators
    
    let newPasswordCoordinator = NewPasswordCoordinator()
    
    // MARK: Public Properties
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: CoordinatorProtocol Methods
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        let nvc = UIStoryboard(name: PasswordsListTableViewController.identifier, bundle: nil).instantiateInitialViewController() as? UINavigationController
        passwordsListTableViewController = nvc?.topViewController as? PasswordsListTableViewController
        passwordsListTableViewController?.viewModel = passwordsListViewModel
        
        viewController.present(nvc!, animated: true, completion: nil)
        
        bindPasswordListViewModel()
        
        return Observable.never()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}

// MARK: Private Methods

private extension PasswordsListCoordinator {
    
    func bindPasswordListViewModel() {
        passwordsListViewModel.newPasswordAction.drive(onNext: { () in
            self.coordinate(to: self.newPasswordCoordinator, from: self.passwordsListTableViewController!).subscribe(onNext: {
                self.passwordsListViewModel.passwordsRefreshObserver.onNext(())
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
}
