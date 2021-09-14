//
//  ZoomImageCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/14.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class ZoomImageCoordinator {
    
    private let viewModel: ZoomImageViewModel
    
    init(viewModel: ZoomImageViewModel) {
        self.viewModel = viewModel
    }
    
    func start(_ masterVC: UIViewController) {
        guard let vc = R.storyboard.zoomImage.zoomImageViewController() else { return }
        vc.viewModel = viewModel
        masterVC.present(vc, animated: true)
    }
}
