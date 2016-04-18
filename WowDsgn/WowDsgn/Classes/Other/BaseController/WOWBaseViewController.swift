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
    var reuestIndex = 0 //翻页
    var isRreshing : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        request()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
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
    
    func request(){
        
    }
    
    func pullToRefresh() {
        if isRreshing {
            return
        }else{
           isRreshing = true
        }
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }

    
}
