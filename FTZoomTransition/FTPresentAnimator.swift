//
//  FTPresentAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

class FTPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning{

    var element : FTZoomTransitionElement!
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!

        let container = transitionContext.containerView

        fromVC.view.frame = container.bounds;
        toVC.view.frame = container.bounds;

        container.addSubview(toVC.view)

        element.sourceSnapView.frame = element.sourceFrame
        container.addSubview(element.sourceSnapView)
        
        
        element.sourceView.isHidden = true
        
        toVC.view.alpha = 0
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations:{
                        
                        self.element.sourceSnapView.frame = self.element.targetFrame

        }, completion: { (completed) -> () in
            
            print("animate done");
            
            self.element.sourceSnapView.isHidden = true
            toVC.view.alpha = 1
            transitionContext.completeTransition(completed)
        })
 
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
        
        
    }
    
 
}
public extension UIView {
    
    public func snapshotImage() -> UIImage? {
        
        let size: CGSize = CGSize(width: floor(self.frame.size.width), height: floor(self.frame.size.height))
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        let snapshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshot
    }
}
