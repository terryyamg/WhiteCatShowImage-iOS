//
//  BaseViewController.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/6.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var loadingView: LoadingView = LoadingView()
    
    func initView() {
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make -> Void in
            make.edges.equalToSuperview()
        }
    }
}
