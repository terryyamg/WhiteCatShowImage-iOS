//
//  RoleData.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/23.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
/*
* "SW"   劍
* "NAC"  拳
* "WAR"  斧
* "LAN"  槍
* "AR"   弓
* "MAG"  魔
* "TSW"  雙
* "DR"   龍
* "VAR"  變
* "BS"   大劍
* "SAB"  輝劍
* "CHAIN" 鎖鏈
* */
enum Career: CaseIterable {
    case SW, NAC, WAR, LAN, AR, MAG, TSW, DR, VAR, BS, SAB, CHAIN
    
    var lowercaseString: String {
        switch self {
        case .SW: return "sw"
        case .NAC: return "nac"
        case .WAR: return "war"
        case .LAN: return "lan"
        case .AR: return "ar"
        case .MAG: return "mag"
        case .TSW: return "tsw"
        case .DR: return "dr"
        case .VAR: return "var"
        case .BS: return "bs"
        case .SAB: return "sab"
        case .CHAIN: return "chain"
        }
    }
}

struct RoleData: DetailUrlProtocol {
    var name: String
    var image: String
    var career: Career
    var detailUrl: String = ""
}
