//
//  ExtensionString.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/7/11.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import UIKit

enum LanguageType: String, CaseIterable {
    case english = "en"
    case traditional = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    
    var title: String {
        switch self {
        case .english: return "common_english".localized
        case .traditional: return "common_traditional".localized
        case .japanese: return "common_japanese".localized
        case .korean: return "common_korean".localized
        }
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }

    var localized: String {
        // English: Base, Japanese: ja, Traditional: zh-Hant
        if UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang) == nil {
            UserDefaults.standard.set(UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang), forKey: SingletonVariable.sharedInstance().userLang)
        }

        var lang: String = UserDefaults.standard.string(forKey: SingletonVariable.sharedInstance().userLang) ?? LanguageType.traditional.rawValue
        switch lang {
        case LanguageType.traditional.rawValue:
            lang = "zh-Hant"
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

// string to date
extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.date(from: self)
    }
}
