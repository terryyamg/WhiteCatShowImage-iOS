//
//  GameEventCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/15.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class GameEventCoordinator: BaseCoordinator, CoordinatorDependency {
    private let viewModel: GameEventViewModel
    
    var dependency: AppDependency?
    
    init(viewModel: GameEventViewModel) {
        self.viewModel = viewModel
    }

    override func start() {
        guard let vc = R.storyboard.gameEvent.gameEventViewController() else { return }
        vc.viewModel = viewModel
        navigationController.viewControllers = [vc]
    }
}
