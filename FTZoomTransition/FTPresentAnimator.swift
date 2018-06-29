//
//  FTPresentAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    public var config : FTZoomTransitionConfig!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return max(0.3, config.presentAnimationDuriation)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if config == nil {
            return
        }
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size)
        toVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size);
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        self.config.sourceSnapView.frame = config.sourceFrame
        container.addSubview(config.sourceSnapView)
        self.config.sourceView.isHidden = true
        self.config.targetView.isHidden = true
        toVC.view.alpha = 0
        
        let zoomScale : CGFloat = self.config.targetFrame.size.width/self.config.sourceFrame.size.width
        
        if self.config.enableZoom == true {
            let sourcePoint : CGPoint = self.config.sourceFrame.origin
            let targetPoint : CGPoint = self.config.targetFrame.origin
            var anchorPoint : CGPoint = CGPoint(x: (abs(sourcePoint.x*zoomScale)-targetPoint.x)/container.bounds.size.width, y: (abs((sourcePoint.y*zoomScale)-targetPoint.y))/container.bounds.size.height)
            if sourcePoint.x >= container.bounds.size.width/2 {
                anchorPoint = CGPoint(x: (self.config.sourceFrame.origin.x + self.config.sourceFrame.size.width)/container.bounds.size.width, y: (abs(sourcePoint.y*zoomScale-targetPoint.y))/container.bounds.size.height)
            }
            fromVC.view.setAnchorPoint(anchorPoint: anchorPoint)
        }
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                delay: 0,
                                options: UIView.KeyframeAnimationOptions.calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                                        self.config.sourceSnapView.frame = self.config.targetFrame
                                        fromVC.view.alpha = 0
                                    })
                                    
                                    if self.config.enableZoom == true {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                                            fromVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
                                        })
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                                        toVC.view.alpha = 1
                                    })
        }, completion: { (completed) -> () in
            self.config.targetView.isHidden = false
            self.config.sourceSnapView.isHidden = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

