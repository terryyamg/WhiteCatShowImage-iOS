//
//  MenuViewController.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/7/11.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MenuCoordinator?
    var viewModel: ViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        bindViewModel()
    }
    
    func initTableView() {
        tableView.register(MenuTableViewCell.nib, forCellReuseIdentifier: MenuTableViewCell.identifier)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? MenuViewModel else { return }
        
        let inputs = MenuViewModel.Input(selection: tableView.rx.modelSelected(MenuItem.self).asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: MenuTableViewCell.identifier,
                    cellType: MenuTableViewCell.self)) { _, menuItem, cell in
                cell.setupInfo(with: menuItem.title)
            }
            .disposed(by: disposeBag)
        
        outputs.selectedEvent.drive(onNext: { [weak self] (menuItem) in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                viewModel.didSelectScreen.onNext(menuItem.item)
            }
        })
        .disposed(by: disposeBag)
        
    }
}
