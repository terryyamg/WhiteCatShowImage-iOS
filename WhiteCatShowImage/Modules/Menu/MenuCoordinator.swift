//
//  MenuCoordinator.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class MenuCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private let menuViewModel: MenuViewModel

    init(menuViewModel: MenuViewModel) {
        self.menuViewModel = menuViewModel
    }

    override func start() {
        menuViewModel.didSelectScreen
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] screen in
                        self?.selectScreen(screen)
            })
            .disposed(by: disposeBag)
        
        let drawerMenu = SideMenuManager.default.leftMenuNavigationController
        let menuViewController = drawerMenu?.topViewController as? MenuViewController
        menuViewController?.viewModel = menuViewModel
    }

    func selectScreen(_ screen: Screen) {
        switch screen {
        case .main:
            removeChildCoordinators()
            let coordinator = MainCoordinator(viewModel: MainViewModel())
            coordinator.navigationController = navigationController
            start(coordinator: coordinator)
        case .history:
            break
        case .gameEvent:
            break
        case .phoneWallpaper:
            break
        case .sixthCharacter:
            break
        case .settings:
            removeChildCoordinators()
            let coordinator = SettingsCoordinator(viewModel: SettingsViewModel())
            coordinator.navigationController = navigationController
            start(coordinator: coordinator)
        }
    }
}
