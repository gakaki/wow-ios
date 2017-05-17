//
//  WOWRefundListController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWRefundListController: WOWApplyAfterBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        request()
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundList(refundOrderStatus: nil), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self{ 
                strongSelf.endRefresh()
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
