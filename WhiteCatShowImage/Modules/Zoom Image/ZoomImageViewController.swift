//
//  ZoomImageViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/13.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ivZoom: UIImageView!
    
    var viewModel: ZoomImageViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        initView()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        guard let image = viewModel.imageString else { return }
        
        ivZoom.kf.setImage(with: URL(string: image),
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
                                self.ivZoom.image = R.image.fail()
                            }
                           })
    }
    
    func initView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ivZoom
    }
}
