//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

public class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    public var element : FTZoomTransitionElement!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if element == nil {
            return
        }
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = container.bounds;
        toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
        toVC.view.frame = container.bounds;
        toVC.view.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(self.element.sourceSnapView)
        
        self.element.sourceSnapView.frame = element.targetFrame
        self.element.sourceSnapView.isHidden = false
        self.element.targetView.isHidden = true

        let zoomScale : CGFloat = self.element.targetFrame.size.width/self.element.sourceFrame.size.width
        
        if self.element.enableZoom == true {
            toVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
        }
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeCubic,
            animations:{
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1, animations: {
                    self.element.sourceSnapView.frame = self.element.sourceFrame
                    toVC.view.alpha = 1
                })
                
                if self.element.enableZoom == true {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1, animations: {
                        toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    })
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                    fromVC.view.alpha = 0
                })
                
                
        }, completion: { (completed) -> () in
            
            if (transitionContext.transitionWasCancelled == true){
                toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
                container.bringSubview(toFront: fromVC.view)
            }
            self.element.sourceView.isHidden = transitionContext.transitionWasCancelled
            self.element.targetView.isHidden = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
