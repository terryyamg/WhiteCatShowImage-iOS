//
//  BaseViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/6.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var topMostViewController: UIViewController? {
        var topVC = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    lazy var loadingView: LoadingView = LoadingView()
    
    func initView() {
        loadingView.alpha = 1.0
        self.topMostViewController?.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }
    }
}
