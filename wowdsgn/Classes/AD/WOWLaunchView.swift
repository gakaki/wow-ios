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
    // 检查更新 接口
    func requestCheakVersion() {

        let params = ["appType": 1, "platForm": 2,"version":ez.appVersion ?? "5.0"] as [String : Any]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_checkVersion(params: params as [String : AnyObject]?), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{

                let json = JSON(result)
                DLog(json)
                
                let model        =  Mapper<WOWUpdateVersionModel>().map(JSONObject: json.object )
                if let model = model {
                    // 检查版本是否更新
                    CheackAppVersion.compareVersion(currentVersion: ez.appBuild ?? "1000", appVersion: model.versionCode ?? 0)
                    
                    if CheackAppVersion.cheackResult == 1 {
                        strongSelf.goToUpdateVersion(m: model)
                        // 需要更新，保存最新版本号
                        CheackAppVersion.NewestVersion = model.version ?? ""
                    }
                  
                    
                }
            }
        }) { (errorMsg) in
            
                WOWHud.dismiss()
            
        }
        
    }
    // 跳转更新提示VC
    func goToUpdateVersion(m: WOWUpdateVersionModel)  {
        
        let vc = WOWMaskViewController()
        vc.updateModel = m
        UIApplication.currentViewController()?.presentToViewController(viewControllerToPresent: vc, completion: nil)

        
    }
    

}
