//
//  ExtensionUIApplication.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/5/23.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import UIKit

extension UIApplication {
    static func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
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
