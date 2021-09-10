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
import SnapKit

class MainViewController: ViewControllerWithSideMenu {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomPager: FSPagerView!

    private let refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    var listCareer: OrderedSet<UIImage> = [#imageLiteral(resourceName: "all"), #imageLiteral(resourceName: "ic_sw.pdf"), #imageLiteral(resourceName: "ic_nac"), #imageLiteral(resourceName: "ic_war"), #imageLiteral(resourceName: "ic_lan"), #imageLiteral(resourceName: "ic_ar"), #imageLiteral(resourceName: "ic_mag"), #imageLiteral(resourceName: "ic_tsw"), #imageLiteral(resourceName: "ic_dr"), #imageLiteral(resourceName: "ic_var"), #imageLiteral(resourceName: "ic_bs"), #imageLiteral(resourceName: "ic_sab")]

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
        initView()
        initTableView()
        bindViewModel()
        initBottomPager()
    }
    
    func initTableView() {
        tableView.register(RoleTableViewCell.nib, forCellReuseIdentifier: RoleTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    func bindViewModel() {
        guard let viewModel = viewModel as? MainViewModel else { return }
        guard let searchButton = navigationItem.rightBarButtonItem else { return }
        
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let inputs = MainViewModel.Input(headerRefresh: refresh,
                                         selection: tableView.rx.modelSelected(RoleData.self).asDriver(),
                                         search: searchButton.rx.tap.asObservable())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoItems
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                    cellIdentifier: RoleTableViewCell.identifier,
                    cellType: RoleTableViewCell.self)) { _, item, cell in
                cell.setupInfo(with: item)
            }
            .disposed(by: disposeBag)
        
        outputs.hiddenLoading
            .subscribe(onNext: { [weak self] _ in
                self?.loadingView.animateHidden()
            })
            .disposed(by: disposeBag)
        
        outputs.selectedEvent.drive(onNext: { roleData in
            viewModel.didSelectRole.onNext(roleData)
            
        })
        .disposed(by: disposeBag)
        
        outputs.searchEvent.asDriver(onErrorJustReturn: [])
            .drive(onNext: { roleDataList in
                viewModel.didClickSearch.onNext(roleDataList)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            cell.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                cell.transform = CGAffineTransform.identity
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func selectedCareerType(_ index: Int) {
        guard let viewModel = viewModel as? MainViewModel else { return }
        guard index != 0 else {
            viewModel.didFilter.onNext((nil, nil))
            return
        }
        let careerType: Career = Career.allCases[index - 1]
        viewModel.didFilter.onNext((careerType, nil))
    }
    
    @objc func refresh(_ sender: AnyObject) {
        headerRefreshTrigger.onNext(())
        refreshControl.endRefreshing()
        initView()
        loadingView.viewLoading.play()
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
        selectedCareerType(index)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        selectedCareerType(targetIndex)
    }
}
