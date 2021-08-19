//
//  SettingsCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/16.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    override func start() {
        guard let vc = R.storyboard.settings.settingsViewController() else { return }
        vc.viewModel = viewModel
        navigationController.viewControllers = [vc]
    }
}
