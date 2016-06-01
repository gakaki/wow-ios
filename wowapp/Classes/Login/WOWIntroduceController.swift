//
//  WOWIntroduceController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/28.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWIntroduceController: WOWBaseViewController {
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func setUI() {
        super.setUI()
        let image = YYImage(named: "intro")
        let imageView = YYAnimatedImageView(image: image)
        imageView.frame = CGRectMake(0, 0, self.view.w, self.view.h)
        self.view.addSubview(imageView)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 4.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            imageView.stopAnimating()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
                mainVC?.modalTransitionStyle = .FlipHorizontal
                AppDelegate.rootVC = mainVC
                self.presentViewController(mainVC!, animated: true, completion: nil)
            })
        })
    }
}

extension WOWIntroduceController:UIWebViewDelegate{
    func webViewDidFinishLoad(webView: UIWebView) {
        DLog("结束了")
    }
}





