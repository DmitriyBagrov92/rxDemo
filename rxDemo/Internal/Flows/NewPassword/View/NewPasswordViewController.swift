//
//  NewPasswordViewController.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewPasswordViewController: UIViewController, Identifierable, ViewControllerProtocol {
    
    // MARK: ViewControllerProtocol Properties
    
    typealias VM = NewPasswordViewModel
    
    var viewModel: NewPasswordViewModel!
    
    // MARK: - IBOutlets: Views
    
    @IBOutlet weak var serviceNameTextField: UITextField!
    
    @IBOutlet weak var generateButton: UIButton!
    
    @IBOutlet weak var passwordDescriptionLabel: UILabel!
    
    @IBOutlet weak var passwordLengthSlider: UISlider!
    
    @IBOutlet weak var passwordLengthLabel: UILabel!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var activityView: UIView!
    
    // MARK: Private Properties
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: Lyfecircle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }

}

// MARK: Private Methods

private extension NewPasswordViewController {
    
    func bindUI() {
        serviceNameTextField.rx.text.bind(to: viewModel.serviceNameObserver).disposed(by: disposeBag)

        viewModel.isGenerateButtonEnabled.drive(generateButton.rx.isEnabled).disposed(by: disposeBag)
        generateButton.rx.tap.bind(to: viewModel.generateActionObserver).disposed(by: disposeBag)
        
        viewModel.passwordString.drive(passwordDescriptionLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.passwordLengthString.drive(passwordLengthLabel.rx.text).disposed(by: disposeBag)        
        passwordLengthSlider.rx.value.map({ Int($0) }).bind(to: viewModel.passwordLengthObserver).disposed(by: disposeBag)
        
        viewModel.isDoneActionButtonEnabled.drive(doneBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        
        doneBarButtonItem.rx.tap.bind(to: viewModel.doneActionObserver).disposed(by: disposeBag)
        
        viewModel.passwordCreationActivityHidden.drive(activityView.rx.isHidden).disposed(by: disposeBag)
    }
    
}
