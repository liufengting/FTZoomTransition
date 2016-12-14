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
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if element == nil {
            return
        }
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let container = transitionContext.containerView
        
        fromVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size)
        toVC.view.frame = CGRect(origin: CGPoint.zero, size: container.bounds.size);
        container.addSubview(fromVC.view)
        container.addSubview(toVC.view)
        
        self.element.sourceSnapView.frame = element.sourceFrame
        container.addSubview(element.sourceSnapView)
        
        self.element.sourceView.isHidden = true
        self.element.targetView.isHidden = true

        toVC.view.alpha = 0

        let zoomScale : CGFloat = self.element.targetFrame.size.width/self.element.sourceFrame.size.width
        
        if self.element.enableZoom == true {
            let sourcePoint : CGPoint = self.element.sourceFrame.origin
            let targetPoint : CGPoint = self.element.targetFrame.origin
            //        let anchorPoint : CGPoint = CGPoint(x: (targetPoint.x + sourcePoint.x)/2, y: (targetPoint.y + sourcePoint.y)/2)
            
            
            if sourcePoint.x < container.bounds.size.width/2 {
                fromVC.view.setAnchorPoint(anchorPoint: CGPoint(x: sourcePoint.x/container.bounds.size.width, y: (sourcePoint.y*zoomScale-targetPoint.y)/container.bounds.size.height))
            }else{
                fromVC.view.setAnchorPoint(anchorPoint: CGPoint(x: (self.element.sourceFrame.origin.x + self.element.sourceFrame.size.width)/container.bounds.size.width, y: (sourcePoint.y*zoomScale-targetPoint.y)/container.bounds.size.height))
            }
            
            //        let ab = CATransform3DMakeScale(zoomScale, zoomScale, 1)
            //        let ac = CATransform3DMakeTranslation(10, 20, 0)
            //        let combinedTransform = CATransform3DConcat(ab, ac)
        }


        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .calculationModeCubic,
            animations: {

                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                    self.element.sourceSnapView.frame = self.element.targetFrame
                    fromVC.view.alpha = 0

                })
                if self.element.enableZoom == true {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1, animations: {
                        fromVC.view.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1)
                    })
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                    toVC.view.alpha = 1
                })
                
                
        }, completion: { (completed) -> () in
            
            
            self.element.targetView.isHidden = false
            self.element.sourceSnapView.isHidden = true
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension CGRect {
    
    func center() -> CGPoint {
        return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height/2)
    }
    
}


extension UIView {
    
    // solution found at: http://stackoverflow.com/a/5666430/6310268
    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
    
}
