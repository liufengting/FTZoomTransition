//
//  ViewController.swift
//  FTZoomTransition
//
//  Created by liufengting on 29/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sourceButton: UIButton!
    
    let ftZoomTransition = FTZoomTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleButtonTap(_ sender: UIButton) {
        
        // present


        let detial = self.storyboard?.instantiateViewController(withIdentifier: "DetialNavigationController") as! UINavigationController
        let detialVC = detial.viewControllers[0] as! DetialViewController
        
        let sourceRect = sender.convert(sender.bounds, to: UIApplication.shared.keyWindow)
        let targetRect = detialVC.targetImageView.convert(detialVC.targetImageView.bounds, to: UIApplication.shared.keyWindow)
        
        ftZoomTransition.interactiveAnimator.wireToViewController(detialVC)

        let element = FTZoomTransitionElement(sourceView: sender,
                                              sourceSnapView: sender.snapshotView(afterScreenUpdates: false)!,
                                              sourceFrame: sourceRect,
                                              targetView: detialVC.targetImageView,
                                              targetFrame: targetRect)
        
//        element.enableZoom = true
        
        ftZoomTransition.element = element
        
        
        detial.transitioningDelegate = ftZoomTransition
        self.present(detial, animated: true, completion: {})

    }

}

