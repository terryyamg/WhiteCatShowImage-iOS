//
//  TableViewCellProtocol.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/24.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

protocol TableViewCellProtocol {
    static var nib: UINib { get }
    static var identifier: String { get }
    static var suggestedHeight: CGFloat { get }
}

extension TableViewCellProtocol {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    static var suggestedHeight: CGFloat {
        return 32
    }
}
