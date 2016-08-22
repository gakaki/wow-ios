//
//  WOWPaySuccessController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPaySuccessController: WOWBaseViewController {
    var orderid     = ""
    var totalPrice  = ""
    var payMethod   = ""
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var successView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付结果"
        
        successView.layer.borderWidth = 2
        successView.layer.cornerRadius = 26
        successView.layer.masksToBounds = true
        successView.layer.borderColor = UIColor.blackColor().CGColor
        
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = MGRgb(151, g: 151, b: 151).CGColor
        dotteShapLayer.lineWidth = 0.5
        CGPathMoveToPoint(mdotteShapePath, nil, 15, 162)
        CGPathAddLineToPoint(mdotteShapePath, nil, MGScreenWidth - 15, 162)
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [2,2])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.view.layer.addSublayer(dotteShapLayer)
        
        orderIdLabel.text = orderid
        orderCountLabel.text = totalPrice
        payMethodLabel.text = payMethod
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     查看订单详情
     */
     @IBAction func goOrderDetailClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderid
        vc.entrance = orderDetailEntrance.orderPay
        navigationController?.pushViewController(vc, animated: true)
    }

    override func navBack() {
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
}

