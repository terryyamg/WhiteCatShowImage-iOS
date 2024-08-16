//
//  DetailsViewModel.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/2.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftSoup
import Collections

enum DetailModelType {
    case details, gameEventDetails
}

class DetailsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let refresh: Observable<Void>
    }
    
    struct Output {
        let todoUrlList: Observable<OrderedDictionary<String, String>>
        let hiddenLoading: PublishSubject<Void>
    }
    
    // MARK: Private
    private var imageUrlList = BehaviorRelay<OrderedDictionary<String, String>>(value: [:])
    private var disposeBag: DisposeBag = DisposeBag()
    private let networkManager: NetworkManagerProtocol?
    private let detailData: DetailUrlProtocol?
    private var type: DetailModelType = .details
    var images: OrderedDictionary<String, String> = [:]
    
    private lazy var specialHandleUrl: [String] = {
        var list: [String] = []
        list.append("https://gamewith.jp/shironeko/article/show/239998")
        list.append("https://gamewith.jp/shironeko/article/show/240017")
        list.append("https://gamewith.jp/shironeko/article/show/241600")
        list.append("https://gamewith.jp/shironeko/article/show/240748")
        list.append("https://gamewith.jp/shironeko/article/show/241404")
        return list
    }()
    
    // Input
    let didSelectImage = PublishSubject<String>()
    
    init(networkManager: NetworkManagerProtocol, detailData: DetailUrlProtocol, type: DetailModelType) {
        self.networkManager = networkManager
        self.detailData = detailData
        self.type = type
    }
    
    func transform(input: Input) -> Output {
        input.refresh.flatMapLatest({ [weak self] () -> Observable<OrderedDictionary<String, String>> in
            guard let self = self else { return Observable.just([:]) }
            guard let detailData = self.detailData else { return Observable.just([:]) }
            return self.type == .details ? self.getRoleDetailsFromUrl(dataUrl: detailData.detailUrl) : self.getGameEventDetailsFromUrl(data: detailData)
        })
        .subscribe(onNext: { [weak self] imageUrlList in
            guard let self = self else { return }
            self.imageUrlList.accept(imageUrlList)
            self.images = imageUrlList
            self.loading.onNext(())
        }).disposed(by: disposeBag)
        
        return Output(todoUrlList: imageUrlList.asObservable(),
                      hiddenLoading: loading)
    }
    
    private func getRoleDetailsFromUrl(dataUrl: String) -> Observable<OrderedDictionary<String, String>> {
        return Observable.create { subscriber in
            self.networkManager?.getHtmlFromURL(urlString: dataUrl,
                                                completionHandler: { html in
                do {
                    var imageUrlDic: OrderedDictionary<String, String> = [:]
                    let doc: Document = try SwiftSoup.parse(html)
                    let elements = try doc.select("div#article-body")
                    
                    let src = try elements
                        .select("h2.article-comment.js-article-comment").first()?
                        .nextElementSibling()?
                        .select("img")
                        .attr("src")
                    
                    // 處理兩種一般圖
                    if let src = src, src.isEmpty {
                        let doubleSrc = try elements
                            .select("a.js-w-slide-changer")
                        try doubleSrc.forEach { elements in
                            let newSrc = try elements.attr("data-image")
                            imageUrlDic[newSrc] = ""
                        }
                    } else {
                        if let src = src {
                            imageUrlDic[src] = ""
                        }
                    }
                    
                    var specialSrc = try elements
                        .select("a.w-article-img.article-img-zoom-wrap")
                        .attr("href")
                    
                    if specialSrc.isEmpty || self.specialHandleUrl.contains(dataUrl) {
                        specialSrc = try elements
                            .select("div.js-accordion-area.accordion-area")
                            .select("img")
                            .attr("data-original")
                    }
                    imageUrlDic[specialSrc] = ""
                    subscriber.onNext(imageUrlDic)
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
    }
    
    private func getGameEventDetailsFromUrl(data: DetailUrlProtocol) -> Observable<OrderedDictionary<String, String>> {
        return Observable.create { subscriber in
            guard let eventData = data as? EventData else {
                return Disposables.create()
            }
            let dataUrl = eventData.detailUrl
            self.networkManager?.getHtmlFromURL(urlString: dataUrl,
                                                completionHandler: { html in
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let elements = try doc.select("div.chara.motion")
                    
                    var wpElements = try doc.select("div.wpArea").select("a")
                    var urlDic: OrderedDictionary<String, String> = [:]
                    
                    try wpElements.forEach { item in
                        if try item.attr("href").contains("lp") {
                            try urlDic[self.urlColopl + item.attr("href")] = item.text()
                        } else {
                            try urlDic[dataUrl + item.attr("href").dropFirst()] = item.text()
                        }
                    }
                    
                    let wpElementsSection = try doc.select("section.wpArea").select("a")
                    try wpElementsSection.forEach { item in
                        if try item.attr("href").contains("lp") {
                            try urlDic[self.urlColopl + item.attr("href")] = item.text()
                        } else {
                            try urlDic[dataUrl + item.attr("href")] = item.text()
                        }
                    }
                    
                    // 2021聖誕後找不到上面的
                    if urlDic.isEmpty {
                        wpElements = try doc.select("div[class^=c-wallpaperList__download is-cover]").select("a")
                        try wpElements.forEach { item in
                            try urlDic[dataUrl + item.attr("href")] = item.text()
                        }
                    }
                    
                    if urlDic.isEmpty {
                        wpElements = try doc.select("div.wallpaper-container").select("a")
                        try wpElements.forEach { item in
                            try urlDic[self.urlColopl + item.attr("href")] = item.text()
                        }
                    }
                    
                    // 2022 Saint Shine格式
                    if urlDic.isEmpty {
                        wpElements = try doc.select("div[class^=special__item_wallpaper motion fadeInUp]").select("a")
                        try wpElements.forEach { item in
                            try urlDic[self.urlColopl + item.attr("href")] = item.text()
                        }
                    }
                    
                    // 2022 茶熊格式
                    if urlDic.isEmpty {
                        wpElements = try doc.select("div.wallpaper__content").select("a")
                        try wpElements.forEach { item in
                            try urlDic[dataUrl + item.attr("href")] = item.text()
                        }
                    }
                    
                    subscriber.onNext(urlDic)
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
    }
    
    private func handleEventDetail(data: EventData) {
        
    }
}
