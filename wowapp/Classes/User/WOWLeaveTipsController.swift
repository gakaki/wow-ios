//
//  WOWLeaveTipsController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWLeaveTipsController: WOWBaseViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "意见反馈"
        view.backgroundColor = DefaultBackColor
        makeCustomerNavigationItem("提交", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.commit()
            }
        }
    }
    
    fileprivate func commit(){
        let tips = textView.text
        if (tips?.isEmpty)! {
            WOWHud.showMsg("请输入您的意见或反馈")
            return
        }
        
    }
    

}
