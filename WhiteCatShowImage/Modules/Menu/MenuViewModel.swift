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

protocol MenuViewModelInput {
//    var langTrigger: Driver<Void> { get }
}

protocol MenuViewModelOutput {
    var todoItems: Observable<[MenuItem]> { get }
}

protocol MenuViewModelType {
    var inputs: MenuViewModelInput { get }
    var outputs: MenuViewModelOutput { get }
}

class MenuViewModel: ViewModel, MenuViewModelType, MenuViewModelInput, MenuViewModelOutput {
    private let items = BehaviorRelay<[MenuItem]>(value: [])

    var todoItems: Observable<[MenuItem]> {
        return items.asObservable()
    }

    var inputs: MenuViewModelInput { return self }
    var outputs: MenuViewModelOutput { return self }
}
