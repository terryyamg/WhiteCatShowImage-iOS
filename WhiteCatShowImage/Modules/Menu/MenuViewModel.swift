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
        MenuItem(screen: .main),
        MenuItem(screen: .history),
        MenuItem(screen: .gameEvent),
        MenuItem(screen: .phoneWallpaper),
        MenuItem(screen: .sixthCharacter),
        MenuItem(screen: .settings)
    ])
    
    private let disposeBag = DisposeBag()
    
    let didSelectScreen = BehaviorSubject(value: Screen.main)
    
    func transform(input: Input) -> Output {
        let selectedEvent = input.selection

        return Output(todoItems: items.asObservable(), selectedEvent: selectedEvent)
    }
}
