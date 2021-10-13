//
//  GameEventViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/15.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameEventViewController: ViewControllerWithSideMenu {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ViewModel?
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        bindViewModel()
    }
    
    func initTableView() {
        tableView.register(GameEventTableViewCell.nib, forCellReuseIdentifier: GameEventTableViewCell.identifier)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? GameEventViewModel else { return }
        let inputs = GameEventViewModel.Input(selection: tableView.rx.modelSelected(EventData.self).asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: GameEventTableViewCell.identifier,
                    cellType: GameEventTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
    }
  
}
