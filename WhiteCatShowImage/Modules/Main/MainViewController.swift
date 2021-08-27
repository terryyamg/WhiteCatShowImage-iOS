//
//  MainViewController.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2019/8/24.
//  Copyright © 2019 楊鎮齊. All rights reserved.
//

import UIKit
import FSPagerView
import RxCocoa
import RxSwift
import Collections

class MainViewController: ViewControllerWithSideMenu {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomPager: FSPagerView!

    private let refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()

    let headerRefreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    var listCareer: OrderedSet<UIImage> = [#imageLiteral(resourceName: "ic_sw.pdf"), #imageLiteral(resourceName: "ic_nac"), #imageLiteral(resourceName: "ic_war"), #imageLiteral(resourceName: "ic_lan"), #imageLiteral(resourceName: "ic_ar"), #imageLiteral(resourceName: "ic_mag"), #imageLiteral(resourceName: "ic_tsw"), #imageLiteral(resourceName: "ic_dr"), #imageLiteral(resourceName: "ic_var"), #imageLiteral(resourceName: "ic_bs"), #imageLiteral(resourceName: "ic_sab")]

    func initBottomPager() {
        viewBottomPager.dataSource = self
        viewBottomPager.delegate = self
        viewBottomPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        viewBottomPager.transformer = FSPagerViewTransformer(type: .linear)
        viewBottomPager.itemSize = CGSize(width: 70, height: 70)
        viewBottomPager.decelerationDistance = FSPagerView.automaticDistance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        bindViewModel()
        initBottomPager()
    }

    func initTableView() {
        tableView.register(RoleTableViewCell.nib, forCellReuseIdentifier: RoleTableViewCell.identifier)
        tableView.addSubview(refreshControl)
    }

    func bindViewModel() {
        guard let viewModel = viewModel as? MainViewModel else { return }
        
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let inputs = MainViewModel.Input(headerRefresh: refresh,
                                         selection: tableView.rx.modelSelected(RoleData.self).asDriver())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: RoleTableViewCell.identifier,
                    cellType: RoleTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MainViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return listCareer.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        cell.imageView?.image = listCareer[index]
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        print("select:\(index)")
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        print("pagerViewWillEndDragging:\(targetIndex)")
    }
}
