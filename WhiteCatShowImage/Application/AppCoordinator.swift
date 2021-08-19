//
//  AppCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator {
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        window.makeKeyAndVisible()
        
        removeChildCoordinators()
        
        let coordinator = MenuCoordinator(menuViewModel: MenuViewModel())
        coordinator.navigationController = BaseNavigationController()
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
}
