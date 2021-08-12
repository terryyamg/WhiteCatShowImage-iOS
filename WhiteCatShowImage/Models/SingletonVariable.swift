//
//  SingletonVariable.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/7/11.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import Foundation

class SingletonVariable {

    private static var singletonVariable: SingletonVariable?

    static func sharedInstance() -> SingletonVariable {
        if singletonVariable == nil {
            singletonVariable = SingletonVariable()
        }
        return singletonVariable!
    }

    /* string */
    // user about
    var userLang: String = "userLang"

}
