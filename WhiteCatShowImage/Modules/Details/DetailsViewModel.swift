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

class DetailsViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let refresh: Observable<Void>
    }

    struct Output {
        let todoUrlList: Observable<[String]>
        let hiddenLoading: PublishSubject<Void>
    }
    
    // MARK: Private
    private var imageUrlList = BehaviorRelay<[String]>(value: [])
    private var disposeBag: DisposeBag = DisposeBag()
    private let networkManager: NetworkManagerProtocol?
    private let roleDataUrl: String?
    var images: [String] = []
    
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
    
    init(networkManager: NetworkManagerProtocol, roleDataUrl: String) {
        self.networkManager = networkManager
        self.roleDataUrl = roleDataUrl
    }
    
    func transform(input: Input) -> Output {
        input.refresh.flatMapLatest({ [weak self] () -> Observable<[String]> in
            guard let self = self else { return Observable.just([]) }
            guard let roleDataUrl = self.roleDataUrl else { return Observable.just([]) }
            print("⭐️roleDataUrl:\(roleDataUrl)")
            return Observable.create { subscriber in
                self.networkManager?.getHtmlFromURL(urlString: roleDataUrl,
                                                    completionHandler: { html in
                    do {
                        var imageUrl: [String] = []
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
                                imageUrl.append(newSrc)
                            }
                        } else {
                            imageUrl.append(src ?? "")
                        }
                        
                        var specialSrc = try elements
                            .select("a.w-article-img.article-img-zoom-wrap")
                            .attr("href")
                        
                        if specialSrc.isEmpty || self.specialHandleUrl.contains(roleDataUrl) {
                            specialSrc = try elements
                                .select("div.js-accordion-area.accordion-area")
                                .select("img")
                                .attr("data-original")
                        }
                        imageUrl.append(specialSrc)
                        subscriber.onNext(imageUrl)
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
        .subscribe(onNext: { [weak self] imageUrlList in
            guard let self = self else { return }
            self.imageUrlList.accept(imageUrlList)
            self.images = imageUrlList
            self.loading.onNext(())
        }).disposed(by: disposeBag)
        
        return Output(todoUrlList: imageUrlList.asObservable(),
                      hiddenLoading: loading)
    }
}
