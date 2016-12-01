//
//  FTDismissAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

class FTDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning{
    
    var element : FTZoomTransitionElement!

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let container = transitionContext.containerView
        
        fromVC.view.frame = container.bounds;
        toVC.view.frame = container.bounds;
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 146, width: 375, height: 375))
//        imageView.image = UIImage(named: "icon")
//        container.addSubview(imageView)
//        element.sourceView.isHidden = false
//        let tempView = element.sourceView.snapshotView(afterScreenUpdates: false)
        self.element.sourceSnapView.frame = element.targetFrame
//        container.addSubview(tempView!)
        
        self.element.sourceSnapView.isHidden = false

        
        fromVC.view.alpha = 0
 
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations:{
                        
                        self.element.sourceSnapView.frame = self.element.sourceFrame

        }, completion: { (completed) -> () in
            
            self.element.sourceView.isHidden = false
            self.element.sourceSnapView.isHidden = true
            toVC.view.alpha = 1
            transitionContext.completeTransition(completed)
        })
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
}
