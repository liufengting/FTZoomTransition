//
//  FTTransitionDelegate.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

public struct FTZoomTransitionElement {
    
    var sourceView : UIView!
    var sourceSnapView : UIView!
    var sourceFrame : CGRect!
    var targetView : UIView!
    var targetFrame : CGRect!
    
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
    public let interActionAnimator = FTInteractiveTransition()
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interActionAnimator.interactionInProgress == true ? interActionAnimator : nil
    }
    
}


public class FTInteractiveTransition : UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    internal weak var navigationController: UINavigationController?
    
    public var interactionInProgress = false
    
    
    fileprivate var shouldCompleteTransition = false
    
    fileprivate weak var viewController: UIViewController!
    
    public func wireToViewController(_ viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        interactionInProgress = true
        viewController.dismiss(animated: true, completion: nil)
        return true
    }
    
    
    func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 300)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
        default: break
        }
    }
    
}
