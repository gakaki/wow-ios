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
    
    @IBOutlet weak var singsTagView: TagListView!
    var orderNewDetailModel : WOWNewOrderDetailModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ m:WOWNewOrderDetailModel, indexRow:Int){
        orderNewDetailModel = m
        
        let orderProductModel = orderNewDetailModel!.unShipOutOrderItems![indexRow]

//        colorLabel.text = orderProductModel.color?.get_formted_Space()
        titleLabel.text = orderProductModel.productName
        singsTagView.textFont = UIFont.systemFont(ofSize: 10)
        for sing in orderProductModel.attributes ?? [""]{
            singsTagView.addTag(sing)
          
        }
        titleImageView.set_webimage_url(orderProductModel.specImg!)
        
        

        let result = WOWCalPrice.calTotalPrice([orderProductModel.sellPrice ?? 0],counts:[1])
        
        priceLabel.text = result
        goodsNumber.text = (orderProductModel.productQty)!.toString.get_formted_X()

//        contentLabel.text = orderProductModel.specName?.get_formted_Space()

        
        
    }
    func showPackages(_ m:WOWNewOrderDetailModel, indexSection:Int, indexRow:Int){
        orderNewDetailModel = m
        let orderProductModel = orderNewDetailModel!.packages![indexSection].orderItems![indexRow]

//        colorLabel.text = orderProductModel.color?.get_formted_Space()
        titleLabel.text = orderProductModel.productName
        singsTagView.textFont = UIFont.systemFont(ofSize: 10)
        for sing in orderProductModel.attributes ?? [""]{
            singsTagView.addTag(sing)
        }

        titleImageView.set_webimage_url(orderProductModel.specImg!)

        
        priceLabel.text = (orderProductModel.sellPrice)!.toString.get_formted_price()
        goodsNumber.text = (orderProductModel.productQty)!.toString.get_formted_X()

//        contentLabel.text = orderProductModel.specName?.get_formted_Space()


        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
