//
//  AppDelegate.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2019/8/24.
//  Copyright © 2019 楊鎮齊. All rights reserved.
//

import UIKit
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var appCoordinator: AppCoordinator!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpSideMenu()
        
        appCoordinator = AppCoordinator()
        appCoordinator.start()

        return true
    }

    private func setUpSideMenu() {
        // Define the menus
        guard let rootViewController = R.storyboard.menu.menuViewController() else { return }
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: rootViewController)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        leftMenuNavigationController.navigationBar.isHidden = true

        let style = SideMenuPresentationStyle.menuSlideIn
        style.backgroundColor = .black
        style.presentingEndAlpha = 0.32
        style.onTopShadowColor = .black
        style.onTopShadowRadius = 4.0
        style.onTopShadowOpacity = 0.2
        style.onTopShadowOffset = CGSize(width: 2.0, height: 0.0)

        var settings = SideMenuSettings()
        settings.presentationStyle = style
        settings.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.75), 240)
        settings.statusBarEndAlpha = 0.0

        leftMenuNavigationController.settings = settings
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
