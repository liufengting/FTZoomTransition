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
    
    public weak var dismissAnimator: FTDismissAnimator!

    fileprivate var shouldCompleteTransition = false
    
    fileprivate weak var viewController: UIViewController!
    
    fileprivate weak var gestureView: UIView!

    
    public func wireToViewController(_ viewController: UIViewController!, for view: UIView) {
        self.viewController = viewController
        self.gestureView = view
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    

    func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        var progress = (translation.y / self.viewController.view.bounds.size.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.3
            self.updateTargetViewFrame(progress, center: gestureRecognizer.location(in: gestureRecognizer.view))
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
                self.finishAnimation()
            }
        default: break
        }
    }
    
    
    func updateTargetViewFrame(_ progress: CGFloat, center: CGPoint) {
        
        let targetframe : CGSize = self.dismissAnimator.element.targetFrame.size
        let currentSize = CGSize(width: targetframe.width*(1-progress), height: targetframe.height*(1-progress))
        let currentOrigin = CGPoint(x: center.x - (currentSize.width/2), y: center.y - (currentSize.height/2) + 64)
        let currentFrame : CGRect = CGRect(origin: currentOrigin, size: currentSize)
        
        self.dismissAnimator.element.sourceSnapView.frame = currentFrame
        
    }
    
    func finishAnimation() {
        self.dismissAnimator.element.sourceView.isHidden = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: UIViewAnimationOptions(),
                       animations: { 
                        self.dismissAnimator.element.sourceSnapView.frame = self.dismissAnimator.element.sourceFrame
        }) { (complete) in
            self.dismissAnimator.element.sourceSnapView.isHidden = true
            self.dismissAnimator.element.sourceView.isHidden = false
        }
    }
    
    
}
