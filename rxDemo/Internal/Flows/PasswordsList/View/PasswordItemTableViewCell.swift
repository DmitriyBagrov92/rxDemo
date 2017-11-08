//
//  PasswordItemTableViewCell.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordItemTableViewCell: UITableViewCell, Identifierable {

    // MARK: Private Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Public Methods
    
    func bind(viewModel: PasswordCellViewModel) {
        viewModel.passwordServiceName.drive(textLabel!.rx.text).disposed(by: disposeBag)
        viewModel.passwordValue.drive(detailTextLabel!.rx.text).disposed(by: disposeBag)
    }
    
}
