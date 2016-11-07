//
//  WOWLaunchView.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/7.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWLaunchView: UIView {
    @IBOutlet weak var backgroundImg: UIImageView!
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        backgroundImg.alpha = 0
//        UIView.animate(withDuration: 1, animations: {
//            self.backgroundImg.alpha = 1
//        })
        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.removeFromSuperview()
        }
    }
    override func removeFromSuperview() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            super.removeFromSuperview()
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
