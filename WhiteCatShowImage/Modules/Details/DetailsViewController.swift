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

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ivRole: UIImageView!
    @IBOutlet weak var viewBottomPager: FSPagerView!
    
    let refreshTrigger = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                
                self.setShowImage(0)
                self.viewBottomPager.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    func initPager() {
        viewBottomPager.dataSource = self
        viewBottomPager.delegate = self
        viewBottomPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        viewBottomPager.transformer = FSPagerViewTransformer(type: .linear)
        viewBottomPager.itemSize = CGSize(width: 70, height: 70)
        viewBottomPager.decelerationDistance = FSPagerView.automaticDistance
    }
    
    private func setShowImage(_ index: Int) {
        guard let viewModel = viewModel as? DetailsViewModel else { return }
        guard !viewModel.images.isEmpty else { return }
        let processor = DownsamplingImageProcessor(size: ivRole.bounds.size)
        
        ivRole.kf.indicatorType = .activity
        ivRole.kf.setImage(with: URL(string: viewModel.images[index]),
                           placeholder: R.image.search_image(),
                           options: [
                            .processor(processor),
                            .transition(.fade(1)),
                            .cacheOriginalImage
                           ], completionHandler: { result in
                            switch result {
                            case .success(let value):
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                                self.ivRole.image = R.image.fail()
                            }
                           })
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
        cell.imageView?.kf.setImage(with: URL(string: viewModel.images[index]), completionHandler: { result in
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
        pagerView.scrollToItem(at: index, animated: true)
        setShowImage(index)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        setShowImage(targetIndex)
    }
}
