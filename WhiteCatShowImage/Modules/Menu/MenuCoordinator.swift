//
//  MenuCoordinator.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import UIKit

class MenuCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators: [Coordinator] = []
    var narigationController: UINavigationController

    init(narigationController: UINavigationController) {
        self.narigationController = narigationController
    }

    func start() {
        guard let vc = R.storyboard.menu.menuViewController()  else { return }
        vc.coordinator = self
        narigationController.pushViewController(vc, animated: true)
    }

    func didFinishMenu() {
        parentCoordinator?.childDidFinish(self)
    }
}
