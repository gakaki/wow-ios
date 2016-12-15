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
            self.requestCheakVersion()
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
    // 检查更新
    func requestCheakVersion() {
        
        let params = ["appType": 1, "platForm": 1,"version":1.5]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_checkVersion(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{

                let json = JSON(result)
                DLog(json)
                strongSelf.goToUpdateVersion()
                
            }
        }) { (errorMsg) in
            
                WOWHud.dismiss()
            
        }
        
    }
    // 跳转更新提示VC
    func goToUpdateVersion()  {
        
        let vc = WOWMaskViewController()
        
        UIApplication.currentViewController()?.presentToViewController(viewControllerToPresent: vc, completion: nil)

        
    }


}
