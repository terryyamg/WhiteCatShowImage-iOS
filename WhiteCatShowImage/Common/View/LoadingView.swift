//
//  LoadingView.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/1.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {

    var view: UIView!
    
    @IBOutlet weak var viewLoading: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)

        viewLoading.contentMode = .scaleAspectFit
        viewLoading.loopMode = .loop
        viewLoading.animationSpeed = 1.5
        viewLoading.play()
    }

    func loadViewFromNib() -> UIView {
        return R.nib.loadingView.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    func animateHidden() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseInOut, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
