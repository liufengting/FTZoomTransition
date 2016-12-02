//
//  DetialViewController.swift
//  FTZoomTransition
//
//  Created by liufengting on 29/11/2016.
//  Copyright © 2016 LiuFengting (https://github.com/liufengting) . All rights reserved.
//

import UIKit

class DetialViewController: UIViewController {

    public lazy var targetImageView : UIImageView = {
        let imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 64, width: 375, height: 375))
        imageView.image = UIImage(named: "icon")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(targetImageView)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(gesture:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func onTap(gesture : UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
}
