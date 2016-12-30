//
//  FTPanDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 28/12/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

public class FTPanDismissAnimator : UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {
    
    public var interactionInProgress = false
    
    fileprivate var shouldCompleteTransition = false
    
    fileprivate weak var viewController: UIViewController!
    
    fileprivate weak var scrollView: UIScrollView!
    
    
    public func wireToViewController(_ viewController: UIViewController!, for scrollView: UIScrollView) {
        self.viewController = viewController
        self.scrollView = scrollView
        
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if scrollView.contentOffset.y <= 0 {
            if let pan : UIPanGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                let translation : CGPoint = pan.translation(in: gestureRecognizer.view!.superview!)
                if translation.y > 0 {
                    interactionInProgress = true
                    viewController.dismiss(animated: true, completion: nil)
                    return true
                }
            }
        }
        return false
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
