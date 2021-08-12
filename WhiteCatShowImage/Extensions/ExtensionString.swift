//
//  ExtensionString.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/7/11.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import UIKit

enum LanguageType: String {
    case english = "en"
    case traditional = "zh-Hant"
    case simplified = "zh-Hans"
    case japanese = "ja"
    case korean = "ko"
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    var localized: String {
        // English: Base, Japanese: ja, Traditional: zh-Hant, Simplified: zh-Hans
        if UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang) == nil {
            UserDefaults.standard.set(UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang), forKey: SingletonVariable.sharedInstance().userLang)
        }

        var lang: String = UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang) ?? LanguageType.traditional.rawValue
        switch lang {
        case LanguageType.traditional.rawValue:
            lang = "zh-Hant"
        case LanguageType.simplified.rawValue:
            lang = "zh-Hans"
        case LanguageType.english.rawValue:
            lang = "en"
        case LanguageType.japanese.rawValue:
            lang = "ja"
        case LanguageType.korean.rawValue:
            lang = "ko"
        default:
            lang = "Base"
        }

        var bundle: Bundle?
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
            bundle = Bundle(path: path)
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")

    }
}
