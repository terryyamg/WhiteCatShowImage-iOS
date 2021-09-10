//
//  DetailsViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/2.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import FSPagerView
import RxCocoa
import RxSwift
import Kingfisher
import Lottie

class DetailsViewController: BaseViewController {
    
    @IBOutlet weak var viewImagePager: FSPagerView!
    @IBOutlet weak var viewBottomPager: FSPagerView!
    
    let refreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
        initPager()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? DetailsViewModel else { return }
        
        let refresh = Observable.of(Observable.just(()), refreshTrigger).merge()
        let inputs = DetailsViewModel.Input(refresh: refresh)
        let outputs = viewModel.transform(input: inputs)
        
        outputs.todoUrlList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] imageUrlList in
                guard let self = self else { return }
                
                self.viewImagePager.reloadData()
                self.viewBottomPager.reloadData()
            })
            .disposed(by: disposeBag)
        
        outputs.hiddenLoading
            .subscribe(onNext: { [weak self] _ in
                self?.loadingView.animateHidden()
            })
            .disposed(by: disposeBag)
    }
    
    func initPager() {
        viewImagePager.dataSource = self
        viewImagePager.delegate = self
        viewImagePager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        viewImagePager.transformer = FSPagerViewTransformer(type: .cubic)
        viewImagePager.decelerationDistance = FSPagerView.automaticDistance
        
        viewBottomPager.dataSource = self
        viewBottomPager.delegate = self
        viewBottomPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        viewBottomPager.transformer = FSPagerViewTransformer(type: .linear)
        viewBottomPager.itemSize = CGSize(width: 70, height: 70)
        viewBottomPager.decelerationDistance = FSPagerView.automaticDistance
    }
    
    private func synchronizeScrollPager(at index: Int, with pagerView: FSPagerView) {
        if pagerView == viewBottomPager {
            viewImagePager.scrollToItem(at: index, animated: true)
        } else {
            viewBottomPager.scrollToItem(at: index, animated: true)
        }
    }
    
}

extension DetailsViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let viewModel = viewModel as? DetailsViewModel else { return 0 }
        return viewModel.images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        guard let viewModel = viewModel as? DetailsViewModel else { return cell }
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: URL(string: viewModel.images[index]),
                                    placeholder: R.image.search_image(),
                                    options: [
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
                                    ], completionHandler: { result in
                                        switch result {
                                        case .success(let value):
                                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                        case .failure(let error):
                                            print("Job failed: \(error.localizedDescription)")
                                            cell.imageView?.image = R.image.fail()
                                        }
                                    })
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        synchronizeScrollPager(at: index, with: pagerView)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        synchronizeScrollPager(at: targetIndex, with: pagerView)
    }
}
