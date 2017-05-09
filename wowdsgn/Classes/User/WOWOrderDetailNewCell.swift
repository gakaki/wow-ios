//
//  WOWOrderDetailNewCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol WOWOrderDetailNewCellDelegate: class {
    func orderGoProductDetail(_ productId: Int?)
}
class WOWOrderDetailNewCell: UITableViewCell {
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var goodsNumber: UILabel!
    @IBOutlet weak var tapView: UIView!
    
    @IBOutlet weak var btnAfterSales: UIButton!
    @IBOutlet weak var singsTagView: TagListView!
    var orderNewDetailModel : WOWNewOrderDetailModel!
    weak var delegeta: WOWOrderDetailNewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        btnAfterSales
        btnAfterSales.addBorder(width: 0.5, color: UIColor.init(hexString: "cccccc")!)
//        btnAfterSales.isHidden = true 
    }
    // 产品UI数据
    func productData(model : WOWNewProductModel!){
        titleLabel.text = model.productName
        singsTagView.textFont = UIFont.systemFont(ofSize: 10)
        singsTagView.removeAllTags()
        for sing in model.attributes ?? [""]{
            singsTagView.addTag(sing)
        }
        titleImageView.set_webimage_url(model.specImg ?? "")
        tapView.addAction({[weak self] in
            if let strongSelf = self {
                if let del = strongSelf.delegeta {
                    del.orderGoProductDetail(model.productId)
                }
            }
        })
        
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        
        priceLabel.text = result
        goodsNumber.text = ((model.productQty) ?? 1).toString.get_formted_X()

    }
    // 展示未发货的数据
    func showData(_ m:WOWNewOrderDetailModel, indexRow:Int){
        
        orderNewDetailModel = m
        
        if let unShipOutItems = orderNewDetailModel.unShipOutOrderItems { // 判断是否为空
            if unShipOutItems.count > indexRow { // 判断时否越界
                let orderProductModel = unShipOutItems[indexRow]
                
                self.productData(model: orderProductModel)
                
            }
        }
        
    }
    // 展示发货的数据
    func showPackages(_ m:WOWNewOrderDetailModel, indexSection:Int, indexRow:Int){
        orderNewDetailModel = m
        if let packages = orderNewDetailModel.packages { // 判断是否为空
            if packages.count > indexSection {
                if let orderItems = packages[indexSection].orderItems {
                    if orderItems.count > indexRow {
                        self.productData(model: orderItems[indexRow])
                    }
                }
            }
        }
        
    }
    @IBAction func clickAfterAction(_ sender: Any) {
        VCRedirect.goApplyAfterSales(sendType: .sendGoods)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
