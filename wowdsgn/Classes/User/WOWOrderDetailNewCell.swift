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
    
    @IBOutlet weak var lbAfterSales: UILabel!
    @IBOutlet weak var singsTagView: TagListView!
    var orderNewDetailModel : WOWNewOrderDetailModel!
    
    let defaultName = "申请售后".get_formted_Space()
    var orderType : OrderNewType?
    
    var orderCode                   : String!
    var saleOrderItemId             : Int!
    
    var productModelData:WOWNewProductModel!
    
    weak var delegeta: WOWOrderDetailNewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbAfterSales.addBorder(width: 0.5, color: UIColor.init(hexString: "cccccc")!)
        lbAfterSales.addTapGesture {[weak self] (sender) in
            if let strongSelf = self {
                strongSelf.clickAfterAction()
            }
        }
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

        let statusName = (model.refundStatusName ?? "").get_formted_Space()

        if model.isRefund ?? false{
            lbAfterSales.text = statusName
        }else if model.isRefundAvailable ?? false {
            lbAfterSales.text = defaultName
        }
        if model.isRefundAvailable ?? false  { //为true 可申请售后，
            if model.isRefund ?? false { // 都为true 说明在申请之中
                 lbAfterSales.text = statusName
         
            }else{// 为false 说明， 没有申请，
                lbAfterSales.text = defaultName

            }
        }else if model.isRefund ?? false{// 都为true 说明在申请之中
              lbAfterSales.text = statusName
  
        }else{
             lbAfterSales.isHidden = true
        }
        
    }

    func clickAfterAction() {
        guard lbAfterSales.text == defaultName else {
            self.gotoApplyAfterVC() // 则说明在审核中  直接跳售后详情界面
            return
        }
        WOWHud.showLoadingSV()
        // 在这里请求接口，判断该个
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundMoney(saleOrderItemId: productModelData.saleOrderItemId ?? 0, isWholeRefund: nil), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
             
                let json = JSON(result)
                DLog(json)
               let isWholeRefund = json["isWholeRefund"].bool
                if let isWholeRefund = isWholeRefund {
                    strongSelf.gotoApplyAfterVC(json: json,isWholeRefund: isWholeRefund)
                }else {
                    strongSelf.gotoApplyAfterVC(json: json)
                }
              
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                print(errorMsg ?? "")
                WOWHud.dismiss()
            }
        }
    }
        // 检查此订单 其他 item 是否有申请 售后的
    func cheackIsRefundItem() -> Bool{
        
        if let packages  = orderNewDetailModel.packages{
            for orderItems in packages {
                if let items = orderItems.orderItems {
                    for order in items {
                        if order.isRefund ?? false {
                            return true
                        }
                    }
                }
            }
        }
        
        if let unShipOutOrderItems = orderNewDetailModel.unShipOutOrderItems {
            for orderItems in unShipOutOrderItems {
                if orderItems.isRefund ?? false {
                    return true
                }
            }
        }
        
        return false

    }
    func gotoApplyAfterVC(json : JSON? = nil,isWholeRefund:Bool = true){
        
            if productModelData.isRefund ?? false { // 如果已经申请过，  则进入 售后详情界面
                VCRedirect.goAfterDetail(productModelData.saleOrderItemRefundId ?? 0)
                return
            }
         

            if productModelData.isDeliveryed ?? false { // 进入申请售后列表页面  区别 未发货 和 已发货
        
                VCRedirect.goApplyAfterSales(sendType: .sendGoods,orderCode:orderCode, saleOrderItemId: productModelData.saleOrderItemId ?? 0,json: json)
        
            }else {
                    // 当订单里有一个item已经申请售后过的， 或者， 订单为部分发货，则不能申请整单退款
                if cheackIsRefundItem() ||  orderType == .someFinishForGoods || isWholeRefund == false{
                    VCRedirect.goApplyAfterSales(sendType: .someNoSend,orderCode:orderCode,saleOrderItemId:productModelData.saleOrderItemId ?? 0,json: json)
                    return
                }
            
                VCRedirect.goApplyAfterSales(sendType: .noSendGoods,orderCode:orderCode,saleOrderItemId:productModelData.saleOrderItemId ?? 0,json: json)
                
                
            }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
