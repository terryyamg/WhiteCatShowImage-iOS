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
}

struct MenuItem {
    var title: String
    var item: Screen
}
