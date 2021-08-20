//
//  SettingsViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/13.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: ViewControllerWithSideMenu {

    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: SettingsCoordinator?
    var viewModel: ViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        bindViewModel()
    }
    
    func initTableView() {
        tableView.register(SettingsTableViewCell.nib, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? SettingsViewModel else { return }
        
        let inputs = SettingsViewModel.Input(selection: tableView.rx.modelSelected(MenuItem.self).asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: SettingsTableViewCell.identifier,
                    cellType: SettingsTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
    }
}
