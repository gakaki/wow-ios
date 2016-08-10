//
//  WOWOrderDetailNewCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderDetailNewCell: UITableViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var goodsNumber: UILabel!
    var orderNewDetailModel : WOWNewOrderDetailModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(m:WOWNewOrderDetailModel){
        orderNewDetailModel = m
        
        let orderProductModel = orderNewDetailModel!.unShipOutOrderItems![0]
        colorLabel.text = orderProductModel.color
        titleLabel.text = orderProductModel.productName
        titleImageView.kf_setImageWithURL(NSURL(string: (orderProductModel.specImg)!)!, placeholderImage: UIImage(named: "placeholder_product"))
        priceLabel.text = "¥" + (orderProductModel.sellPrice)!.toString
        goodsNumber.text = "X" + (orderProductModel.productQty)!.toString
        contentLabel.text = orderProductModel.specName

        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
