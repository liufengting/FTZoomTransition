//
//  FTInteractiveAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 14/12/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

public class FTInteractiveAnimator : UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    public var interactionInProgress = false

    public weak var dismissAnimator: FTDismissAnimator!

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
        var progress = (translation.x / self.viewController.view.bounds.size.width)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
        case .changed:
            shouldCompleteTransition = progress > 0.4
            self.updateTargetViewFrame(progress)
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
    
    
    func updateTargetViewFrame(_ progress: CGFloat) {
        let sourceFrame : CGRect = self.dismissAnimator.element.sourceFrame
        let targetFrame : CGRect = self.dismissAnimator.element.targetFrame
        let x : CGFloat = targetFrame.origin.x - (targetFrame.origin.x - sourceFrame.origin.x)*progress
        let y : CGFloat = targetFrame.origin.y - (targetFrame.origin.y - sourceFrame.origin.y)*progress
        let w : CGFloat = targetFrame.size.width - (targetFrame.size.width - sourceFrame.size.width)*progress
        let h : CGFloat = targetFrame.size.height - (targetFrame.size.height - sourceFrame.size.height)*progress
        
        self.dismissAnimator.element.sourceSnapView.frame = CGRect(x: x, y: y, width: w, height: h)
    }

    
}
