//
//  WOWBaseMackViewController.swift
//  swift-BaseMask
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
let kDuration       = 0.15 // 动画弹出消失时间
let dissDuration    = 0.1  // 背景蒙板弹出消失时间
class WOWBaseMackViewController: UIViewController,CAAnimationDelegate {
    
    var containsView : UIView?  // 内置View
       
    lazy var btnDismiss: UIButton = { // 背景Btn 蒙板
        let btn = UIButton(frame:CGRect.init(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight))
        btn.addTarget(self, action: #selector(dismissBtn), for: .touchUpInside)
        btn.alpha = 0
        btn.backgroundColor = UIColor.black
        return btn
    }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(btnDismiss)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: dissDuration, animations: {
            self.btnDismiss.alpha = 0.5
            self.view.layoutIfNeeded()
        }) { (finished) in
            
           self.showView()
        }

    }
    func showView(){ // 弹出视图
        if let containsView = containsView {
            let animation = CATransition.init()
            animation.delegate = self
            animation.duration = kDuration
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn;
            animation.subtype = kCATransitionFromTop;
            containsView.layer.add(animation, forKey: "LocateViewTop")
            containsView.alpha = 1.0
            self.view.addSubview(containsView)
        }

    }
    func dissView(){// 消失视图
        
        if let containsView = containsView {
            let animation = CATransition.init()
            animation.delegate = self
            animation.duration = kDuration
            animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromBottom;
            containsView.layer.add(animation, forKey: "LocateViewTop")
            containsView.alpha = 0.0

        }
       
    }
    func dismissBtn()  {// 消失蒙板
        self.dissView()
        UIView.animate(withDuration: dissDuration, animations: {
    
            self.btnDismiss.alpha = 0.0
            self.view.layoutIfNeeded()
            
        }) { (finished) in
     
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        DLog("shifang")
    }


}
