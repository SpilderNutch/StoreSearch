//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/17.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject ,UIViewControllerAnimatedTransitioning {

    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        if let fromView = transitionContext.viewForKey(UITransitionContextToViewKey){
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
                
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })
            
            
            
            
        }
    }
}
