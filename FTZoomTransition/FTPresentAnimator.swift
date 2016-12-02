//
//  FTPresentAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

public class FTPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning{

    public var element : FTZoomTransitionElement!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if element == nil {
            return
        }
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let container = transitionContext.containerView

        fromVC.view.frame = container.bounds;
        toVC.view.frame = container.bounds;
        container.addSubview(toVC.view)

        self.element.sourceSnapView.frame = element.sourceFrame
        container.addSubview(element.sourceSnapView)
        
        self.element.sourceView.isHidden = true
        self.element.targetView.isHidden = true

        toVC.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations:{
                        toVC.view.alpha = 1
                        self.element.sourceSnapView.frame = self.element.targetFrame
        }, completion: { (completed) -> () in
            self.element.targetView.isHidden = false
            self.element.sourceSnapView.isHidden = true
            transitionContext.completeTransition(completed)
        })
    }
}

