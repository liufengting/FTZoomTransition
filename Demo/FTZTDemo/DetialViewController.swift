//
//  DetialViewController.swift
//  FTZoomTransition
//
//  Created by liufengting on 29/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit
import FTZoomTransition

class DetialViewController: UIViewController {
    
    public lazy var targetImageView : UIImageView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        imageView.image = UIImage(named: "icon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)));
        return gesture
    }()
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        return pan
    }()
    
    @objc func handleTapGesture(gesture: UIGestureRecognizer) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if let trans: FTZoomTransition = self.navigationController?.transitioningDelegate as? FTZoomTransition {
            trans.panDismissAnimator.handlePanGesture(gesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(targetImageView)
        self.targetImageView.addGestureRecognizer(self.tapGesture);
        
        
        if let trans: FTZoomTransition = self.navigationController?.transitioningDelegate as? FTZoomTransition {
            trans.panDismissAnimator.viewController = self
        }
        self.view.addGestureRecognizer(self.panGesture)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {

        }
    }

}
