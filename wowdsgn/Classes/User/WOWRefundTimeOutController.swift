//
//  WOWRefundTimeOutController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/22.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum RefundTimeOutType {
    case MaxNumber
    case OutTime
}
class WOWRefundTimeOutController: WOWBaseViewController {
    @IBOutlet weak var lbTimerReason: UILabel!
    @IBOutlet weak var viewCoustrom: UIView!
    var type : RefundTimeOutType = .OutTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .OutTime:
            break
        default:
            lbTimerReason.font = UIFont.systemFont(ofSize: 16)
            lbTimerReason.text = "亲，您已不能发起售后"
        }

        viewCoustrom.addTapGesture { (sender) in
            WOWCustomerNeedHelp.show("")

        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
