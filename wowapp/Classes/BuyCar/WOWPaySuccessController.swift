//
//  WOWPaySuccessController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPaySuccessController: WOWBaseViewController {
    var orderid     = "  "
    var totalPrice  = ""
    var payMethod   = "支付宝"
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付成功"
        orderIdLabel.text = orderid
        orderCountLabel.text = totalPrice.priceFormat()
        payMethodLabel.text = payMethod
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func navBack() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
}

