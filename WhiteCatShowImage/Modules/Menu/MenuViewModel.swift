//
//  MenuViewModel.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/7/11.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MenuViewModel: ViewModel, ViewModelType {

    struct Input {
        let selection: Driver<MenuItem>
    }

    struct Output {
        let todoItems: Observable<[MenuItem]>
        let selectedEvent: Driver<MenuItem>
    }
    
    // MARK: Private
    private let items = Observable.just([
        MenuItem(title: "menu_main_page".localized, item: .main),
        MenuItem(title: "menu_history".localized, item: .history),
        MenuItem(title: "menu_game_event".localized, item: .gameEvent),
        MenuItem(title: "menu_phone_wallpaper".localized, item: .phoneWallpaper),
        MenuItem(title: "menu_sixth_character".localized, item: .sixthCharacter),
        MenuItem(title: "menu_settings".localized, item: .settings)
    ])
    
    private let disposeBag = DisposeBag()
    
    let didSelectScreen = BehaviorSubject(value: Screen.main)
    
    func transform(input: Input) -> Output {
        let selectedEvent = input.selection

        return Output(todoItems: items.asObservable(), selectedEvent: selectedEvent)
    }
}
