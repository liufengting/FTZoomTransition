//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    var element : FTZoomTransitionElement!

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if element == nil {
            return
        }
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = container.bounds;
        toVC.view.frame = container.bounds;

        self.element.sourceSnapView.frame = element.targetFrame
        self.element.sourceSnapView.isHidden = false
        self.element.targetView.isHidden = true
        toVC.view.alpha = 1
 
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations:{
                        fromVC.view.alpha = 0
                        self.element.sourceSnapView.frame = self.element.sourceFrame
        }, completion: { (completed) -> () in
            self.element.sourceView.isHidden = false
            self.element.sourceSnapView.isHidden = true
            self.element.targetView.isHidden = false
            transitionContext.completeTransition(completed)
        })
    }
}
