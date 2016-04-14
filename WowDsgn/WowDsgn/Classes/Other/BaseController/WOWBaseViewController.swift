//
//  WOWBaseViewController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBaseViewController: UIViewController {
    var hideNavigationBar:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.sharedApplication().keyWindow?.endEditing(true)
////        if hideNavigationBar {
//            self.navigationController? .setNavigationBarHidden(false, animated: true)
////        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if hideNavigationBar {
            //设置导航栏透明
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUI(){
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    
}
