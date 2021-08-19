//
//  BaseNavigationController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .black
        navigationBar.barTintColor = R.color.main_color()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
