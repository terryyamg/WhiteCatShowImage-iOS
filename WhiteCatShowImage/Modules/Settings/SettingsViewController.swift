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
        
        let inputs = SettingsViewModel.Input(selection: tableView.rx.modelSelected(SettingItem.self).asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: SettingsTableViewCell.identifier,
                    cellType: SettingsTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
        
        outputs.selectedEvent.drive(onNext: { [weak self] (settingItem) in
            guard let self = self else { return }
            switch settingItem.type {
            case .language:
                self.showSelectedAlert()
            case .removeCache:
                break
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func showSelectedAlert() {
        var actions: [UIAlertController.AlertAction] = []
        
        LanguageType.allCases.forEach { type in
            actions.append(.action(title: type.title))
        }

        UIAlertController
            .present(in: self, title: "settings_switch_language".localized, message: nil, style: .alert, actions: actions)
            .subscribe(onNext: { index in
                UserDefaults.standard.set(LanguageType.allCases[index].rawValue, forKey: SingletonVariable.sharedInstance().userLang)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name(SingletonVariable.sharedInstance().changeLang), object: nil)
            })
            .disposed(by: disposeBag)
    }
}
