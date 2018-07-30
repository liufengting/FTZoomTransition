//
//  ViewController.swift
//  FTZoomTransition
//
//  Created by liufengting on 29/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import FTZoomTransition

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
        let screenWidth = UIScreen.main.bounds.size.width
        let targetRect = CGRect(x: 0, y: 64, width: screenWidth, height: screenWidth)
        
        let config = FTZoomTransitionConfig(sourceView: sender,
                                            image: sender.imageView?.image,
                                            targetFrame: targetRect)
        ftZoomTransition.config = config
        ftZoomTransition.wirePanDismissToViewController(detialVC, for: detialVC.targetImageView)
        detial.transitioningDelegate = ftZoomTransition
        self.present(detial, animated: true, completion: {

        })
    }
}

