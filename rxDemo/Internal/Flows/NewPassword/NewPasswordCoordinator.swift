//
//  NewPasswordCoordinator.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class NewPasswordCoordinator: CoordinatorProtocol {
    
    // MARK: Public Properties
    
    var newPasswordViewModel: NewPasswordViewModel!
    
    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: CoordinatorProtocol Methods
    
    func start(from viewController: UIViewController) -> Observable<Void> {
        newPasswordViewModel = NewPasswordViewModel()
        let newPasswordViewController = UIStoryboard(name: NewPasswordViewController.identifier, bundle: nil).instantiateInitialViewController() as? NewPasswordViewController
        newPasswordViewController?.viewModel = newPasswordViewModel
        viewController.navigationController?.pushViewController(newPasswordViewController!, animated: true)
        
        newPasswordViewModel.viewDismiss.drive(onNext: {
            newPasswordViewController?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        return newPasswordViewModel.viewDismiss.asObservable()
    }
    
    func coordinate(to coordinator: CoordinatorProtocol, from viewController: UIViewController) -> Observable<Void> {
        return coordinator.start(from: viewController)
    }
    
}
