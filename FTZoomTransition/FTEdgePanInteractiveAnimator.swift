//
//  FTEdgePanInteractiveAnimator.swift
//  FTZoomTransition
//
//  Created by liufengting on 30/11/2016.
//  Copyright © 2016 LiuFengting. All rights reserved.
//

import UIKit

class FTEdgePanInteractiveAnimator: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    internal weak var navigationController: UINavigationController?
    private var interactive = false
    private weak var poppedVC: UIViewController?
    
    var interactionController: FTEdgePanInteractiveAnimator? {
        return interactive ? self : nil
    }

    func handlePanGestureRecognizer(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .changed:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translation(in: view).x / view.bounds.width
            update(progress)
        case .cancelled, .ended:
            guard let view = recognizer.view else { return }
            let progress = recognizer.translation(in: view).x / view.bounds.width
            let velocity = recognizer.velocity(in: view).x
            if progress > 0.33 || velocity > 1000.0 {
                finish()
            } else {
                
                navigationController?.viewControllers.append(poppedVC!)
                update(0.0)
                cancel()
                
            }
            interactive = false
        default:
            break
        }
    }
    
    
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        interactive = true
        poppedVC  = navigationController?.popViewController(animated: true)
        print("pop")
        return true
        
    }

    
}
