//
//  MainCoordinator.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/18.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainCoordinator: BaseCoordinator, CoordinatorDependency {
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel
    
    var dependency: AppDependency?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    override func start() {
        guard let vc = R.storyboard.main.mainViewController() else { return }
        vc.viewModel = viewModel
        
        navigationController.viewControllers = [vc]
        
        viewModel.didSelectRole
            .subscribe(onNext: { [weak self] roleData in
                guard let self = self else { return }
                let viewModel = DetailsViewModel(networkManager: self.dependency!.networkManager,
                                                 roleDataUrl: roleData.toUrl)
                let coordinator = DetailsCoordinator(viewModel: viewModel)
                coordinator.start(vc)
            })
            .disposed(by: disposeBag)
    }

}
