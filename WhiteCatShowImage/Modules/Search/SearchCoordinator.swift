//
//  SearchCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/8.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class SearchCoordinator {
    private let viewModel: SearchViewModel
    private let parentCoordinator: MainCoordinator
    
    init(viewModel: SearchViewModel, parentCoordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.parentCoordinator = parentCoordinator
    }

    func start(_ masterVC: UIViewController) {
        guard let vc = R.storyboard.search.searchViewController() else { return }
        vc.delegate = self.parentCoordinator
        vc.viewModel = viewModel
        masterVC.present(vc, animated: true)
    }
}
