//
//  DetailsCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/2.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import UIKit

class DetailsCoordinator {
    private let viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }

    func start(_ masterVC: UIViewController) {
        guard let vc = R.storyboard.details.detailsViewController() else { return }
        vc.viewModel = viewModel
        masterVC.present(vc, animated: true)
    }

}
