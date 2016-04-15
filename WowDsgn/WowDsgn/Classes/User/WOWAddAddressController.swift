//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAddAddressController: WOWBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "新增地址"
        navigationItem.leftBarButtonItems = nil
        makeCustomerNavigationItem("取消", left: true) {[weak self] in
            if let strongSelf = self{
                strongSelf.navigationController?.popViewControllerAnimated(true)
            }
        }
        makeCustomerNavigationItem("保存", left: false) {[weak self] in
            if let strongSelf = self{
                DLog("保存")
            }
        }
    }

}
