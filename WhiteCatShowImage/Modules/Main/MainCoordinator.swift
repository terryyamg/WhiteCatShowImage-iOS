//
//  MainCoordinator.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    override func start() {
        guard let vc = R.storyboard.main.mainViewController() else { return }
        vc.viewModel = viewModel
        
        navigationController.viewControllers = [vc]
    }

}
