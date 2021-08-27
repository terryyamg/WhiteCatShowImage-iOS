//
//  AppDependency.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/26.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation

struct AppDependency {
    let networkManager = NetworkManager()
}

protocol CoordinatorDependency {
    var dependency: AppDependency? { get set }
}
