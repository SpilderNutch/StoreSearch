//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by 宇 欧阳 on 16/6/17.
//  Copyright © 2016年 Rocky. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject ,UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
        if  let fromView =  transitionContext.viewForKey(UITransitionContextToViewKey),
            let containerView  = transitionContext.containerView(){
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration, animations: {
                
                fromView.center.y -= containerView.bounds.size.height
                fromView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                
                }, completion: { finished in
                    transitionContext.completeTransition(finished)
            })
            
            
            
            
        }
        
        
        
        
    }
    
}
