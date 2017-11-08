//
//  PasswordListTableViewController.swift
//  rxDemo
//
//  Created by DmitriyBagrov on 11/09/2017.
//  Copyright © 2017 DmitriyBagrov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordsListTableViewController: UITableViewController, ViewControllerProtocol, Identifierable {
    
    // MARK: ViewControllerProtocol Properties
    
    typealias VM = PasswordsListViewModel
    
    var viewModel: PasswordsListViewModel!
    
    // MARK: Public Properties
    
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: - IBOutlets: Views
    
    @IBOutlet weak var newPasswordBarButtonItem: UIBarButtonItem!
    
    // MARK: Lyfecircle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil

        bindUI()
        bindTableViewUI()
    }

}

private extension PasswordsListTableViewController {
    
    func bindUI() {
        newPasswordBarButtonItem.rx.tap.bind(to: viewModel.newPasswordObserver).disposed(by: disposeBag)
    }
    
    func bindTableViewUI() {
        refreshControl = UIRefreshControl()
        
        refreshControl!.rx.controlEvent(.valueChanged).bind(to: viewModel.passwordsRefreshObserver).disposed(by: disposeBag)
        viewModel.passwordRefreshActivity.drive(refreshControl!.rx.isRefreshing).disposed(by: disposeBag)
        
        viewModel.passwords.bind(to: tableView.rx.items(cellIdentifier: PasswordItemTableViewCell.identifier, cellType: PasswordItemTableViewCell.self)) { _, viewModel, cell in
            cell.bind(viewModel: viewModel)
        }.disposed(by: disposeBag)

    }
    
}
