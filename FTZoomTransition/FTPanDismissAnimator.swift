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

    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        var progress = (translation.y / self.viewController.view.bounds.size.height)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.2
            self.updateTargetViewFrame(progress, translation: translation)
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
    
    
    func updateTargetViewFrame(_ progress: CGFloat, translation: CGPoint) {
        let sourceFrame : CGRect = self.dismissAnimator.config.targetFrame
        let targetWidth = sourceFrame.width*(1-progress)
        let targetHeight = sourceFrame.height*(1-progress)
        let targetX = sourceFrame.origin.x + sourceFrame.size.width/2 - targetWidth/2 + translation.x
        let targetY = sourceFrame.origin.y + sourceFrame.size.height/2 - targetHeight/2 + translation.y

        self.dismissAnimator.config.sourceSnapView.frame = CGRect(x: targetX, y: targetY, width: targetWidth, height: targetHeight)
    }
    
    let animationOption = UIViewAnimationOptions.curveEaseIn
    func finishAnimation() {
        self.dismissAnimator.config.sourceView.isHidden = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: animationOption,
                       animations: { 
                        self.dismissAnimator.config.sourceSnapView.frame = self.dismissAnimator.config.sourceFrame
        }) { (complete) in
            self.dismissAnimator.config.sourceSnapView.isHidden = true
            self.dismissAnimator.config.sourceView.isHidden = false
        }
    }
}
