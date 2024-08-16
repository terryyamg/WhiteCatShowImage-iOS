//
//  EventData.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/28.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation

protocol DetailUrlProtocol {
    var detailUrl: String { get set }
}

struct EventData: DetailUrlProtocol {
    var url: String
    var detailUrl: String = ""
    var title: String
    var date: String
}
