//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    public var config : FTZoomTransitionConfig!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return max(0.3, config.dismissAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if config == nil {
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
        container.addSubview(self.config.sourceSnapView)
        
        self.config.sourceSnapView.frame = config.targetFrame
        self.config.sourceSnapView.isHidden = false
        self.config.targetView.isHidden = true
        
        let zoomScale : CGFloat = self.config.targetFrame.size.width/self.config.sourceFrame.size.width
        
        if self.config.enableZoom == true {
            toVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
        }
        
        let keyframeAnimationOption = UIViewKeyframeAnimationOptions.calculationModeCubic
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: keyframeAnimationOption,
                                animations:{
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1, animations: {
                                        toVC.view.alpha = 1
                                        if (!transitionContext.isInteractive) {
                                            self.config.sourceSnapView.frame = self.config.sourceFrame
                                        }
                                    })
                                    if self.config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration:  1, animations: {
                                            toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
                                        })
                                    }
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                                        fromVC.view.alpha = 0
                                    })
                                    
        }, completion: { (completed) -> () in
                                    
                                    if (transitionContext.transitionWasCancelled == true){
                                        if self.config.enableZoom == true {
                                            toVC.view.layer.transform = CATransform3DMakeScale(1, 1, 1)
                                        }
                                        container.bringSubview(toFront: fromVC.view)
                                    }
                                    self.config.sourceSnapView.isHidden = transitionContext.transitionWasCancelled
                                    self.config.sourceView.isHidden = transitionContext.transitionWasCancelled
                                    self.config.targetView.isHidden = !transitionContext.transitionWasCancelled
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
