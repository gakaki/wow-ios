//
//  WOWOrderDetailSThreeCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderDetailSThreeCell: UITableViewCell {
    @IBOutlet weak var personNameLabel: UILabel! // 收货人姓名和手机号
    @IBOutlet weak var addressLabel: UILabel!// 收货人地址
    var orderNewDetailModel : WOWNewOrderDetailModel!
//     @IBOutlet weak var productTitleLabel: UILabel!// 产品小标题
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ m:WOWNewOrderDetailModel){
        orderNewDetailModel = m
        
        personNameLabel.text = (orderNewDetailModel.receiverName) ?? "" + "  " + (orderNewDetailModel.receiverMobile?.get_formted_xxPhone() ?? "")
        
        addressLabel.text = orderNewDetailModel.receiverAddress
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
