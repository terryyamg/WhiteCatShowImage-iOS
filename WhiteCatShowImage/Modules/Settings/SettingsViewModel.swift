//
//  SettingsViewModel.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/13.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SettingsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let selection: Driver<MenuItem>
    }
    
    struct Output {
        let todoItems: Observable<[SettingItem]>
    }
    
    // MARK: Private
    private let items = Observable.just([
        SettingItem(image: UIImage(systemName: "globe"), imageColor: #colorLiteral(red: 0.3612649544, green: 0.9090801056, blue: 0.3285151441, alpha: 1), title: "settings_language".localized),
        SettingItem(image: UIImage(systemName: "trash.circle"), imageColor: #colorLiteral(red: 0.8035734621, green: 0.0002703748898, blue: 0.1059275236, alpha: 1), title: "settings_remove_cache".localized)
    ])
    
    func transform(input: Input) -> Output {
        return Output(todoItems: items.asObservable())
    }
    
    //    var clickItem = PublishSubject<Int>()
    //    private let items = BehaviorRelay<[MenuItem]>(value: [])
    //
    //    var todoItems: Observable<[MenuItem]> {
    //        return items.asObservable()
    //    }
    //
    //    var inputs: MenuViewModelInput { return self }
    //    var outputs: MenuViewModelOutput { return self }
}
