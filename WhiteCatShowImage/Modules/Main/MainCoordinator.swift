//
//  MainCoordinator.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var narigationController: UINavigationController

    init(narigationController: UINavigationController) {
        self.narigationController = narigationController
    }

    func start() {
        guard let vc = R.storyboard.main.mainViewController() else { return }
        vc.coordinator = self
        narigationController.pushViewController(vc, animated: false)
    }

    func pushMenu() {
        let child = MenuCoordinator(narigationController: narigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
        }
    }

}
