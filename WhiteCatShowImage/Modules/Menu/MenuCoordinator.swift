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

class MenuCoordinator: BaseCoordinator, CoordinatorDependency {
    private let disposeBag = DisposeBag()
    private let menuViewModel: MenuViewModel

    var dependency: AppDependency?
    
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
        removeChildCoordinators()
        switch screen {
        case .main:
            let viewModel = MainViewModel(networkManager: dependency!.networkManager)
            let coordinator = MainCoordinator(viewModel: viewModel)
            coordinator.dependency = dependency
            coordinator.navigationController = navigationController
            start(coordinator: coordinator)
        case .history:
            break
        case .gameEvent:
            let viewModel = GameEventViewModel(networkManager: dependency!.networkManager)
            let coordinator = GameEventCoordinator(viewModel: viewModel)
            coordinator.dependency = dependency
            coordinator.navigationController = navigationController
            start(coordinator: coordinator)
        case .phoneWallpaper:
            break
        case .sixthCharacter:
            break
        case .settings:
            let coordinator = SettingsCoordinator(viewModel: SettingsViewModel())
            coordinator.navigationController = navigationController
            start(coordinator: coordinator)
        }
    }
}
