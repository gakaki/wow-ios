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
    
    var orderCode                   : String!
    var saleOrderItemId             : Int!
    
    var productModelData:WOWNewProductModel!
    
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
        productModelData = model
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
        
        priceLabel.text     = result
        goodsNumber.text    = ((model.productQty) ?? 1).toString.get_formted_X()
//        let statusStr = ""
        if  model.isRefundAvailable ?? false {
            btnAfterSales.setTitle("申请售后", for: .normal)
        }else if model.isRefund ?? false{
            btnAfterSales.setTitle(model.refundStatusName ?? "", for: .normal)
        }else {
            btnAfterSales.isHidden = true
        }
 
//        refundStatusName
    }

    @IBAction func clickAfterAction(_ sender: Any) {
        if productModelData.isRefund ?? false { // 如果已经申请过，  则进入 售后详情界面
            VCRedirect.goAfterDetail(productModelData.saleOrderItemRefundId ?? 0)
            return
        }
        if productModelData.isDeliveryed ?? false { // 进入申请售后列表页面  区别 未发货 和 已发货
            
            VCRedirect.goApplyAfterSales(sendType: .sendGoods,orderCode:orderCode, saleOrderItemId: productModelData.saleOrderItemId ?? 0)
            
        }else {
            
            VCRedirect.goApplyAfterSales(sendType: .noSendGoods,orderCode:orderCode,saleOrderItemId:productModelData.saleOrderItemId ?? 0)
            
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
