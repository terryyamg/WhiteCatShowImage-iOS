//
//  SettingItem.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/20.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

enum SettingType {
    case language
    case removeCache
    
    var localized: String {
        switch self {
        case .language: return "settings_language".localized
        case .removeCache: return "settings_remove_cache".localized
        }
    }
}

struct SettingItem {
    var image: UIImage?
    var imageColor: UIColor?
    var type: SettingType
}
