//
//  SearchViewModel.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/8.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModel, ViewModelType {
    
    // MARK: Private
    private let roleDataList: [RoleData]?
    private let enableSaveButton = PublishSubject<Bool>()
    
    init(roleDataList: [RoleData]) {
        self.roleDataList = roleDataList
    }
    
    struct Input {
        let selection: Driver<RoleData>
        let save: Driver<Void>
        let searchBarText: Driver<String>
    }

    struct Output {
        let todoItems: Observable<[RoleData]>
        let selectedEvent: Driver<RoleData>
        let saveEvent: Driver<Void>
        let isEnableButton: PublishSubject<Bool>
    }

    // MARK: Private
    private var items = BehaviorRelay<[RoleData]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let selectedEvent = input.selection
        selectedEvent.asObservable()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.enableSaveButton.onNext(true)
            })
            .disposed(by: disposeBag)
        
        let saveEvent = input.save
        
        self.items.accept(roleDataList ?? [])
        
        input.searchBarText.asObservable()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                guard text.isEmpty else {
                    self.enableSaveButton.onNext(true)
                    return
                }
                self.enableSaveButton.onNext(false)
            })
            .disposed(by: disposeBag)
        
        return Output(todoItems: items.asObservable(),
                      selectedEvent: selectedEvent,
                      saveEvent: saveEvent,
                      isEnableButton: enableSaveButton)
    }
}
