//
//  WOWOrderDetailTwoCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderDetailTwoCell: UITableViewCell {
    @IBOutlet weak var orderNumberLabel: UILabel! // 订单号
    @IBOutlet weak var orderTimeLabel: UILabel! // 下单时间
    @IBOutlet weak var orderTypeLabel: UILabel! // 订单状态
    var orderNewDetailModel : WOWNewOrderDetailModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func showData(m:WOWNewOrderDetailModel){
        orderNewDetailModel = m
        
        orderNumberLabel.text = "订单： " + (orderNewDetailModel!.orderCode)!
        
        
        orderTypeLabel.text = orderNewDetailModel!.orderStatusName
        orderTimeLabel.text = "下单时间：" + (orderNewDetailModel!.orderCreateTimeFormat)!
        switch m.orderStatus! {
        case 4,5,6:
            orderTypeLabel.textColor = UIColor.init(hexString: "000000")
        default:
            break
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
