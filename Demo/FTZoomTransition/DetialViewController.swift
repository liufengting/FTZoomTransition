//
//  DetialViewController.swift
//  FTZoomTransition
//
//  Created by liufengting on 29/11/2016.
//  Copyright © 2016 LiuFengting <https://github.com/liufengting>. All rights reserved.
//

import UIKit

class DetialViewController: UIViewController {
    
    
    public lazy var targetImageView : UIImageView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth))
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(targetImageView)
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true) { 
            print("dismiss done")
        }

    }

}
