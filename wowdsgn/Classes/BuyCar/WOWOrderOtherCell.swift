//
//  WOWOrderOtherCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/17.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOrderOtherCell: UITableViewCell {
    
    @IBOutlet weak var deductionLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel : UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(orderInfo: WOWEditOrderModel) {
        let amount = WOWCalPrice.calTotalPrice([orderInfo.discountAmount], counts: [1])
        deductionLabel.text = String(format: "－%@", amount) //优惠金额
        deliveryFeeLabel.text = WOWCalPrice.calTotalPrice([orderInfo.deliveryFee ?? 0], counts: [1]) //运费金额
        var productQty = 0
        for product in orderInfo.orderSettles  ?? [WOWCarProductModel](){
            productQty = (product.productQty ?? 0) + productQty
        }
        countLabel.text = "共\(productQty)件"
        amountLabel.text = WOWCalPrice.calTotalPrice([orderInfo.totalAmount ?? 0], counts: [1])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
