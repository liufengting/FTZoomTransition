//
//  FTTransitionDelegate.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

open class FTZoomTransitionConfig {
    
    open var sourceView: UIView?
    open var sourceFrame = CGRect.zero
    open var targetFrame = CGRect.zero
    open var enableZoom : Bool = false
    open var presentAnimationDuriation : TimeInterval = 0.3
    open var dismissAnimationDuriation : TimeInterval = 0.3
    open lazy var transitionImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    static func maxAnimationDuriation() -> TimeInterval {
        return 0.3
    }
    
    public convenience init(sourceView: UIView, image: UIImage?, targetFrame: CGRect) {
        self.init()
        self.sourceView = sourceView
        self.targetFrame = targetFrame
        self.transitionImageView.image = image
        if self.sourceView != nil {
            self.sourceFrame = (self.sourceView?.superview?.convert((self.sourceView?.frame)!, to: UIApplication.shared.keyWindow))!;
        }
    }
}

open class FTZoomTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    open var config : FTZoomTransitionConfig! {
        willSet{
            presentAnimator.config = newValue
            dismissAnimator.config = newValue
        }
    }
    
    final let presentAnimator = FTPresentAnimator()
    final let dismissAnimator = FTDismissAnimator()
    final let panDismissAnimator = FTPanDismissAnimator()
    
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
        } else {
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
