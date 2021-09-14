//
//  TopViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/14.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

protocol TopViewControllerProtocol {
    func topViewController(controller: UIViewController?) -> UIViewController?
}

extension TopViewControllerProtocol {
    func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
