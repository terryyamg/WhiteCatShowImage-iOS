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
        viewModel = MenuViewModel()
        initTableView()
        bindViewModel()
    }

    func initTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(MenuTableViewCell.nib, forCellReuseIdentifier: MenuTableViewCell.identifier)
    }

    func bindViewModel() {
//        guard let viewModel = viewModel as? MenuViewModel else { return }
//        let outputs = viewModel.outputs

        let items = Observable.just([
            "事件".localized,
            "語系"
        ])

        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier) as? MenuTableViewCell else { return UITableViewCell() }
                cell.labTitle.text = element
                return cell
            }
            .disposed(by: disposeBag)

//        outputs.todoItems
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items(
//                    cellIdentifier: MenuTableViewCell.identifier,
//                cellType: MenuTableViewCell.self)) { _, menuItem, cell in
//                cell.setupInfo(with: menuItem)
//            }
//            .disposed(by: bag)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishMenu()
    }

}

//extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as? MenuTableViewCell else {
//            return UITableViewCell()
//        }
//        cell.labTitle.text = "Title"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return MenuTableViewCell.suggestedHeight
//    }
//}
