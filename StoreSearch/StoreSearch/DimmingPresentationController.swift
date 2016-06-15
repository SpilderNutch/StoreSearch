//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/12.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {

    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    //当新的viewController出现在屏幕时，就会被调用
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, atIndex: 0)
    }
    
    
}
