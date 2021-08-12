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

class MainViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var viewBottomPager: FSPagerView!

    weak var coordinator: MainCoordinator?
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
        viewModel = MainViewModel()
        bindViewModel()
        initBottomPager()
    }

    func bindViewModel() {
//        guard let viewModel = viewModel as? MainViewModel else { return }

        btnMenu.rx.tap
            .subscribe(onNext: { [weak self] () in
                print("🏀")
                self?.coordinator?.pushMenu()
            }).disposed(by: disposeBag)

//        let input = MainViewModel.Input(menuTrigger: btnMenu.rx.tap.asDriver())
//        let output = viewModel.transform(input: input)
//        output.showMenu.drive(onNext: { [weak self] () in
//            print("🏀")
//        }).disposed(by: disposeBag)
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

}
