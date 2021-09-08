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
import SwiftSoup

class MainViewModel: ViewModel, ViewModelType {
    struct Input {
        let headerRefresh: Observable<Void>
        let selection: Driver<RoleData>
    }

    struct Output {
        let todoItems: Observable<[RoleData]>
        let selectedEvent: Driver<RoleData>
        let isLoading: PublishSubject<Void>
    }

    // MARK: Private
    private var items = BehaviorRelay<[RoleData]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()
    private let networkManager: NetworkManagerProtocol?
    
    private var roleData: [RoleData] = []
    private let filterData = PublishSubject<Career?>()
    // Input
    var triggerFilter: AnyObserver<Career?>
    let didSelectRole = BehaviorSubject<RoleData>(value: RoleData(name: "", image: "", career: .SW, toUrl: ""))
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        
        triggerFilter = filterData.asObserver()
    }
    
    func transform(input: Input) -> Output {
        let selectedEvent = input.selection
        
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[RoleData]> in
            guard let self = self else { return Observable.just([]) }
            return Observable.create { subscriber in
                self.networkManager?.getHtmlFromURL(urlString: "https://gamewith.jp/shironeko/article/show/4040",
                                                    completionHandler: { html in
                    do {
                        var roleList: [RoleData] = []
                        let doc: Document = try SwiftSoup.parse(html)
                        try Career.allCases.forEach { career in
                            let elementsName = try doc.select("tr[class^=w-idb-element  \(career.lowercaseString)]").select("a")
                            try elementsName.forEach { element in
                                let name = try element.text()
                                let image = try element.select("img").attr("data-original")
                                let toUrl = try element.attr("href")
                                let roleData = RoleData(name: name,
                                                        image: image,
                                                        career: career,
                                                        toUrl: toUrl)
                                roleList.append(roleData)
                            }
                        }
                        subscriber.onNext(roleList)
                        subscriber.onCompleted()
                        
                    } catch Exception.Error(let type, let message) {
                        print(type)
                        print(message)
                        subscriber.onCompleted()
                    } catch {
                        print("error")
                        subscriber.onCompleted()
                    }
                })
                return Disposables.create()
            }
        })
        .subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            self.items.accept(item)
            self.loading.onNext(())
            self.roleData = item
        }).disposed(by: disposeBag)

        filterData.bind { [weak self] career in
            guard let self = self else { return }
            guard let career = career else {
                self.items.accept(self.roleData)
                return
            }
            self.items.accept(self.roleData.filter({ $0.career == career }))
        }
        .disposed(by: disposeBag)
        
        return Output(todoItems: items.asObservable(),
                      selectedEvent: selectedEvent,
                      isLoading: loading)
    }
}
