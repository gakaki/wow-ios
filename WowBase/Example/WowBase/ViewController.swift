//
//  ViewController.swift
//  WowBase
//
//  Created by gakaki on 08/20/2016.
//  Copyright (c) 2016 gakaki. All rights reserved.
//

import UIKit
import WowBase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let x               = CGFloat(300)
//        let y               = CGFloat(100)
//        let width           = CGFloat(50)
//        let height          = CGFloat(50)
        
//        let frame           = CGRectMakeAdapt(x, y, width, height)
        let frame           = CGRectMake( 20.w, 0.h, 100.w, 100.h)
        let label           = UILabel(frame: frame)
        label.text          = "I'am a"
        self.view.addSubview(label)
        
        let res = test()
        
        
        print(res)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

//int to cgfloat