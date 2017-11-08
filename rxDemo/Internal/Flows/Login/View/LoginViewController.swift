//
//  LoginViewController.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 04/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, ViewControllerProtocol, Identifierable {
    
    // MARK: ViewControllerProtocol Properties
    
    typealias VM = LoginViewModel
    
    var viewModel: LoginViewModel!
    
    // MARK: Private Properties
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: - IBOutlets: Controls
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    // MARK: Lyfecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUIActions()
    }
    
}

private extension LoginViewController {
    
    func bindUIActions() {
        loginTextField.rx.text.bind(to: viewModel.inputUserLogin).disposed(by: disposeBag)
        
        viewModel.isDoneButtonEnabled.drive(doneBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        
        doneBarButtonItem.rx.tap.bind(to: viewModel.doneActionObserver).disposed(by: disposeBag)
    }
    
}
