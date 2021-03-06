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
    @IBOutlet weak var timeButton: UIButton!
    var isCheackUpdate : Bool = false
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        startTime()
        let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {[weak self] in
            if let strongSelf = self {
                if strongSelf.isCheackUpdate == false {
                    strongSelf.removeView()
                }
            

            }
        }
        

    }
    
    func startTime() {
        let basicAnimation = POPBasicAnimation.linear()
        basicAnimation?.property = POPAnimatableProperty.property(withName: "linearCountdownAnimation", initializer: {(property) in
            property?.writeBlock = { [unowned self](object,values) in//在这里设置动画内容
                if let value = values?[0] {
                    if value < 1 {
                    
                        self.timeButton.setTitle("跳过 ", for: .normal)
                    }else {
                        
                        self.timeButton.setTitle("跳过 " + String(format:"%.0f",value), for: .normal)

                    }
                }
                
            }
        }) as! POPAnimatableProperty
        basicAnimation?.duration = 5.0
        basicAnimation?.fromValue = 5
        basicAnimation?.toValue = 0
        timeButton.pop_add(basicAnimation, forKey: "countdown")
    }
    override func removeFromSuperview() {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }, completion: { (finished: Bool) in
            
           
            super.removeFromSuperview()
        })
    }
    @IBAction func timeClick(sender: UIButton!) {

        if isCheackUpdate == false {
            self.removeView()
        }

    }
    func removeView() {
        
        self.requestCheakVersion()
        self.removeFromSuperview()
    }
    // 检查更新 接口
    func requestCheakVersion() {
        self.isCheackUpdate = true
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
