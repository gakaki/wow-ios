//
//  WOWPaySuccessController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPayResultController: WOWBaseViewController {
    var orderIdArr  = [WOWOrderCodeModel]()
    var totalPrice  = ""
    var payMethod   = ""
    @IBOutlet weak var orderIdLabel1: UILabel!
    @IBOutlet weak var orderIdLabel2: UILabel!
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!// 订单总金额
    @IBOutlet weak var successView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付结果"
        
        successView.layer.borderWidth = 2
        successView.layer.cornerRadius = 26
        successView.layer.masksToBounds = true
        successView.layer.borderColor = UIColor.black.cgColor
        
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
        dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = MGRgb(151, g: 151, b: 151).cgColor
        dotteShapLayer.lineWidth = 0.5
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 0))
        
        mdotteShapePath.move(to: CGPoint(x: 15, y: 162))
        mdotteShapePath.addLine(to: CGPoint(x: MGScreenWidth - 15, y: 162))
        
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [2,2])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.view.layer.addSublayer(dotteShapLayer)
        
        if orderIdArr.count > 1 {
            orderIdLabel1.text = orderIdArr[0].orderCode
            orderIdLabel2.text = orderIdArr[1].orderCode

        }
        orderAmountLabel.text = totalPrice
        payMethodLabel.text = payMethod
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     查看订单详情
     */
    @IBAction func goOrderDetailClick(_ sender: UIButton) {
        goOrderList()
    }
    
    func goOrderList()  {
        MobClick.e(.My_Orders)
        let vc = WOWOrderListViewController()
        vc.entrance = orderDetailEntrance.orderPay
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func navBack() {
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
}

