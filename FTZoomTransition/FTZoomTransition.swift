//
//  FTTransitionDelegate.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTZoomTransitionConfig {
    
    public var sourceView = UIView()
    public var sourceSnapView = UIView()
    public var sourceFrame = CGRect.zero
    public var targetView = UIView()
    public var targetFrame = CGRect.zero
    public var enableZoom : Bool = false
    public var presentAnimationDuriation : TimeInterval = 0.3
    public var dismissAnimationDuriation : TimeInterval = 0.3
    
    public convenience init(sourceView: UIView, targetView: UIView, targetFrame: CGRect) {
        self.init()
        self.sourceView = sourceView
        self.targetView = targetView
        self.targetFrame = targetFrame
        self.sourceFrame = (self.sourceView.superview?.convert(self.sourceView.frame, to: UIApplication.shared.keyWindow))!;
        self.sourceSnapView = self.sourceView.snapshotView(afterScreenUpdates: false)!;
    }
}

public class FTZoomTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    public var config : FTZoomTransitionConfig! {
        willSet{
            presentAnimator.config = newValue
            dismissAnimator.config = newValue
        }
    }
    
    public let presentAnimator = FTPresentAnimator()
    public let dismissAnimator = FTDismissAnimator()
    public let panDismissAnimator = FTPanDismissAnimator()
    
    public func wirePanDismissToViewController(_ viewController: UIViewController!, for view: UIView) {
        self.panDismissAnimator.wireToViewController(viewController, for: view)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if panDismissAnimator.interactionInProgress == true {
            panDismissAnimator.dismissAnimator = dismissAnimator
            return panDismissAnimator
        }else{
            return nil
        }
    }
}

public extension UIView {
    
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
