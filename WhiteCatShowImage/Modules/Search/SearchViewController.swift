//
//  SearchViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/8.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import FSPagerView
import RxCocoa
import RxSwift
import Kingfisher

protocol SearchDelegate: AnyObject {
    func searchText(_ text: String)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ivSave: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomPager: FSPagerView!
    
    weak var delegate: SearchDelegate?
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        bindViewModel()
    }
    
    func initTableView() {
        tableView.register(RoleTableViewCell.nib, forCellReuseIdentifier: RoleTableViewCell.identifier)
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? SearchViewModel else { return }
        let inputs = SearchViewModel.Input(selection: tableView.rx.modelSelected(RoleData.self).asDriver(),
                                           save: btnSave.rx.tap.asDriver(),
                                           searchBarText: searchBar.rx.text.orEmpty.asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: RoleTableViewCell.identifier,
                    cellType: RoleTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
        
        outputs.selectedEvent.drive(onNext: { [weak self] roleData in
            guard let self = self else { return }
            self.searchBar.text = roleData.name
        })
        .disposed(by: disposeBag)
        
        outputs.saveEvent.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let text = self.searchBar.text else { return }
            self.dismiss(animated: true) {
                self.delegate?.searchText(text)
            }
        })
        .disposed(by: disposeBag)
        
        outputs.isEnableButton
            .asDriver(onErrorJustReturn: true)
            .map({ [weak self] isEnable in
                guard let self = self else { return false }
                guard isEnable else {
                    self.ivSave.image = R.image.confirm_disable()
                    return false
                }
                self.ivSave.image = R.image.confirm()
                return true
            })
            .drive(btnSave.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}
