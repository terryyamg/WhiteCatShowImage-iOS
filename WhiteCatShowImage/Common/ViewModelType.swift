//
//  ViewModelType.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/6/20.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
