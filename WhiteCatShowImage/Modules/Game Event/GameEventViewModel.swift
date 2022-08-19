//
//  GameEventViewModel.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/15.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftSoup

class GameEventViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let selection: Driver<EventData>
    }
    
    struct Output {
        let todoItems: Observable<[EventData]>
        let selectedEvent: Driver<EventData>
    }
    // MARK: Private
    private let urlColopl = "https://colopl.co.jp/"
    private let networkManager: NetworkManagerProtocol?
    private var items = BehaviorRelay<[EventData]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var specialHandleUrl: [String] = {
        var list: [String] = []
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2020/news_20200721002.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2020/news_20200413001.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2020/20_0319_01.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2018/news_20181026001.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2018/news_20180810000.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2018/news_20180714005.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news/img/dummy.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2018/news_20180209001.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2018/news_20180126001.jpg")
        list.append("https://colopl.co.jp//shironekoproject/news_pub/img/2017/news_20171207004.jpg")
       return list
    }()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func transform(input: Input) -> Output {
        let selectedEvent = input.selection
        
        Observable.just(()).flatMapLatest({ [weak self] () -> Observable<[EventData]> in
            guard let self = self else { return Observable.just([]) }
            return Observable.create { subscriber in
                let urlString = "\(self.urlColopl)shironekoproject/news/"
                self.networkManager?.getHtmlFromURL(urlString: urlString,
                                                    completionHandler: { html in
                    do {
                        var eventList: [EventData] = []
                        let doc: Document = try SwiftSoup.parse(html)
                        
                        // 計算頁數
                        var maxPage = try doc.select("ul.paging_link").select("a.link_last").attr("href")
                        maxPage = maxPage.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        
                        guard let maxPageInt = Int(maxPage) else { return }
                        let dispatchGroup = DispatchGroup()
                        // 第1頁~最大頁
                        for index in 1 ..< maxPageInt {
                            
                            var nextUrl = urlString
                            nextUrl += (index == 1) ? "index.php" : "index_\(index).php"

                            dispatchGroup.enter()
                            self.networkManager?.getHtmlFromURL(urlString: nextUrl,
                                                                completionHandler: { html in
                                do {
                                    let docNext: Document = try SwiftSoup.parse(html)
                                    let elementsNext = try docNext.select("ul.entryList").select("li.entry")
                                    try elementsNext.forEach { item in
                                        let imageUrl = try self.urlColopl + item.select("img").attr("src")
                                        // 跳過沒用的url
                                        if self.specialHandleUrl.contains(imageUrl) {
                                            return
                                        }
                                        var detailUrl = ""
                                        let urlColopl = try item.select("a").attr("href")
                                        // 部分網頁會已經存在https
                                        if urlColopl.contains("https") {
                                            detailUrl = urlColopl
                                        } else {
                                            detailUrl = self.urlColopl + urlColopl
                                        }
                                        
                                        let div = try item.select("div.textWrap")
                                        let title = try div.select("h3.entryTitle").text()
                                        let date = try String(div.select("p.date").text().prefix(10))
                                        if try !div.select("p.date").select("span").text().contains("GAME EVENT") {
                                            return
                                        }

                                        // 比 2018.03.10 更早的跳過
                                        if let isEarlier = self.isEarlierThanEventDate(date, compareDate: "2018.03.10"), isEarlier {
                                            return
                                        }
                                        
                                        let eventData = EventData(url: imageUrl,
                                                                  detailUrl: detailUrl,
                                                                  title: title,
                                                                  date: date)
                                        eventList.append(eventData)
                                    }
                                    dispatchGroup.leave()
                                    
                                } catch Exception.Error(let type, let message) {
                                    print(type)
                                    print(message)
                                    dispatchGroup.leave()
                                    subscriber.onCompleted()
                                } catch {
                                    print("error")
                                    dispatchGroup.leave()
                                    subscriber.onCompleted()
                                }
                            })
                            
                        }
                        dispatchGroup.notify(queue: .main) {
                            eventList = eventList.sorted { $0.date > $1.date }
                            subscriber.onNext(eventList)
                            subscriber.onCompleted()
                        }
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
        }).disposed(by: disposeBag)
        
        return Output(todoItems: items.asObservable(), selectedEvent: selectedEvent)
    }
    
    private func isEarlierThanEventDate(_ eventDate: String, compareDate: String) -> Bool? {
        guard let eventDate = eventDate.toDate(), let compareDate = compareDate.toDate() else {
            return nil
        }
        return eventDate.compare(compareDate) == .orderedAscending
    }
}
