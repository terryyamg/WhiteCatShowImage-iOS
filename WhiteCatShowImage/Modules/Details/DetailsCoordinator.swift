//
//  DetailsCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/2.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsCoordinator {
    private let disposeBag = DisposeBag()
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    func start(_ masterVC: UIViewController) {
        guard let vc = R.storyboard.details.detailsViewController() else { return }
        vc.viewModel = viewModel
        masterVC.present(vc, animated: true)
    }

}
