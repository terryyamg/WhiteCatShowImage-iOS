//
//  MainViewModel.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2020/5/23.
//  Copyright © 2020 楊鎮齊. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelInput {
    var menuTrigger: PublishSubject<Void> { get }
}

protocol MainViewModelOutput {
    var showMenu: Driver<Void> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}

class MainViewModel: ViewModel {

//    private let loading = BehaviorRelay<Bool>(value: false)
//
//    // Input
//    var menuTrigger: PublishSubject<Void> = PublishSubject<Void>()
//
//    // Output
//    var showMenu: Driver<Void> {
//        return menuTrigger.asDriver()
//    }
//
//    var inputs: MainViewModelInput { return self }
//    var outputs: MainViewModelOutput { return self }

//    struct Input {
//        let menuTrigger: Driver<Void>
//    }
//
//    struct Output {
//        let showMenu: Driver<Void>
//    }
//
//    func transform(input: Input) -> Output {
//        let showMenu = input.menuTrigger.asDriver()
//        return Output(showMenu: showMenu)
//    }
}
