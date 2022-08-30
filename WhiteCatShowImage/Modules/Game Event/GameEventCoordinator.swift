//
//  GameEventCoordinator.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/15.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift

class GameEventCoordinator: BaseCoordinator, CoordinatorDependency {
    private let disposeBag = DisposeBag()
    private let viewModel: GameEventViewModel
    
    var dependency: AppDependency?
    
    init(viewModel: GameEventViewModel) {
        self.viewModel = viewModel
    }

    override func start() {
        guard let vc = R.storyboard.gameEvent.gameEventViewController() else { return }
        vc.viewModel = viewModel
        navigationController.viewControllers = [vc]
        
        viewModel.didSelectEvent
            .subscribe(onNext: { [weak self] eventData in
                guard let self = self else { return }
                let viewModel = DetailsViewModel(networkManager: self.dependency!.networkManager,
                                                 dataUrl: eventData.detailUrl,
                                                 type: .gameEventDetails)
                let coordinator = DetailsCoordinator(viewModel: viewModel)
                coordinator.start(vc)
                
                // 點選圖片 > 進入縮放圖片
                viewModel.didSelectImage
                    .subscribe(onNext: { imageString in
                        guard let vc = self.topViewController() else { return }
                        let viewModel = ZoomImageViewModel(imageString: imageString)
                        let coordinator = ZoomImageCoordinator(viewModel: viewModel)
                        coordinator.start(vc)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
    }
}

extension GameEventCoordinator: TopViewControllerProtocol {}
