//
//  ExtensionDate.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/5/23.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import Foundation

extension Date {
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
