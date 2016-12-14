//
//  FTTransitionDelegate.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

public class FTZoomTransitionElement {
    
    var sourceView : UIView!
    var sourceSnapView : UIView!
    var sourceFrame : CGRect!
    var targetView : UIView!
    var targetFrame : CGRect!
    var enableZoom : Bool = false
    
    
    public init(sourceView: UIView, sourceSnapView : UIView, sourceFrame: CGRect, targetView: UIView, targetFrame: CGRect) {
        self.sourceView = sourceView
        self.sourceSnapView = sourceSnapView
        self.sourceFrame = sourceFrame
        self.targetView = targetView
        self.targetFrame = targetFrame
    }
}

public class FTZoomTransition: NSObject, UIViewControllerTransitioningDelegate{
    
    public var element : FTZoomTransitionElement! {
        willSet{
            presentAnimator.element = newValue
            dismissAnimator.element = newValue
        }
    }
    
    public let presentAnimator = FTPresentAnimator()
    public let dismissAnimator = FTDismissAnimator()
    public let interactiveAnimator = FTInteractiveAnimator()
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator.interactionInProgress == true ? interactiveAnimator : nil
    }
    
}


