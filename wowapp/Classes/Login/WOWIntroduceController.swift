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
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.w, height: self.view.h)
        self.view.addSubview(imageView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 4.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            imageView.stopAnimating()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
                mainVC?.modalTransitionStyle = .flipHorizontal
                AppDelegate.rootVC = mainVC
                self.present(mainVC!, animated: true, completion: nil)
            })
        })
    }
}

extension WOWIntroduceController:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DLog("结束了")
    }
}






