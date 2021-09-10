//
//  ViewControllerWithSideMenu.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import SideMenu

class ViewControllerWithSideMenu: BaseViewController {
    var panGesture = UIPanGestureRecognizer()
    var edgeGesture = UIScreenEdgePanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        edgeGesture = SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: navigationController!.view, forMenu: .left)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet.indent"), style: .plain, target: self, action: #selector(menuClicked))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "menuButton"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "searchButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableSideMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        disableSideMenu()
    }
    
    func disableSideMenu() {
        panGesture.isEnabled = false
        edgeGesture.isEnabled = false
    }
    
    func enableSideMenu() {
        panGesture.isEnabled = true
        edgeGesture.isEnabled = true
    }
    
    @objc func menuClicked() {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
}
