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
    func showData(m:WOWNewOrderDetailModel, indexRow:Int){
        orderNewDetailModel = m
        
        let orderProductModel = orderNewDetailModel!.unShipOutOrderItems![indexRow]
        colorLabel.text = " " + (orderProductModel.color ?? " ") + "   "
        titleLabel.text = orderProductModel.productName
//        titleImageView.kf_setImageWithURL(NSURL(string: (orderProductModel.specImg)!)!, placeholderImage: UIImage(named: "placeholder_product"))
        
        titleImageView.set_webimage_url( orderProductModel.specImg )

        let result = WOWCalPrice.calTotalPrice([orderProductModel.sellPrice ?? 0],counts:[1])
        
        priceLabel.text = result
        goodsNumber.text = "X" + (orderProductModel.productQty)!.toString
        contentLabel.text = " " + (orderProductModel.specName ?? " ") + "   "

        
        
    }
    func showPackages(m:WOWNewOrderDetailModel, indexSection:Int, indexRow:Int){
        orderNewDetailModel = m
        let orderProductModel = orderNewDetailModel!.packages![indexSection].orderItems![indexRow]
        colorLabel.text = " " + (orderProductModel.color ?? " ") + "   "
        titleLabel.text = orderProductModel.productName
//        titleImageView.kf_setImageWithURL(NSURL(string: (orderProductModel.specImg)!)!, placeholderImage: UIImage(named: "placeholder_product"))
        
        titleImageView.set_webimage_url( orderProductModel.specImg )

        
        priceLabel.text = "¥" + (orderProductModel.sellPrice)!.toString
        goodsNumber.text = "X" + (orderProductModel.productQty)!.toString
        contentLabel.text = " " + (orderProductModel.specName ?? " ") + "   "


        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
