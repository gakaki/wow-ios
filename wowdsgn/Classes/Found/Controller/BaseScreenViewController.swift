//
//  BaseScreenViewController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/1/6.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
// 页面如果有筛选，则只需，继承这个类就可以。
class BaseScreenViewController: WOWBaseViewController {
    
    var screenView          : WOWScreenView!
    var screenBtnimg        = UIImageView()
    /* 筛选条件 */
    var screenColorArr     = [String]()
    var screenStyleArr     = [String]()
    var screenPriceArr     = Dictionary<String, AnyObject>()
    var screenScreenArr    = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
   
    override func setUI() {
        super.setUI()
         configScreeningView()
    }
    //MARK:筛选界面
    func configScreeningView()  {
        screenView = WOWScreenView(frame:CGRect(x: ScreenViewConfig.frameX,y: 0,width: MGScreenWidth - ScreenViewConfig.frameX,height: MGScreenHeight))
        
        screenView.screenAction = {[unowned self] (dic) in
            print(dic)
            let dicResult = dic as! [String:AnyObject]
            if dicResult["colorList"] != nil {
                self.screenColorArr  = dicResult["colorList"] as! [String]
            }
            if dicResult["priceObj"] != nil {
                self.screenPriceArr  = dicResult["priceObj"] as! Dictionary
            }
            
            if dicResult["styleList"] != nil {
                self.screenStyleArr  = dicResult["styleList"] as! [String]
            }
            
            if dicResult["sceneList"] != nil {
                self.screenScreenArr  = dicResult["sceneList"] as! [String]
            }
            
            self.request()
        }
        
        
        screenBtnimg.image = UIImage.init(named: "screen")
        screenBtnimg.addTapGesture(action: {[weak self] (tap) in
            if let strongSelf = self{
                
                strongSelf.screenView.showInView(view: UIApplication.shared.keyWindow!)
            }
        })
    
        self.view.addSubview(screenBtnimg)
        screenBtnimg.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.right.bottom.equalTo(-30)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
