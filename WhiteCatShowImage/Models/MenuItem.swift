//
//  MenuItem.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/24.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation

enum Screen {
    case main, history, gameEvent, phoneWallpaper, sixthCharacter, settings

    var localized: String {
        switch self {
        case .main: return "menu_main_page".localized
        case .history: return "menu_history".localized
        case .gameEvent: return "menu_game_event".localized
        case .phoneWallpaper: return "menu_phone_wallpaper".localized
        case .sixthCharacter: return "menu_sixth_character".localized
        case .settings: return "menu_settings".localized
        }
    }
}

struct MenuItem {
    var screen: Screen
}
