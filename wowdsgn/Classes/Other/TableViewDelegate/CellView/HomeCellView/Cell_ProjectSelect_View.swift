//
//  Cell_ProjectSelect_View.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/13.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class Cell_ProjectSelect_View: UIView {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var oneBtn: UIButton!// 上面 第一个btn
    @IBOutlet weak var twoBtn: UIButton!// 上面 第二个btn
    @IBOutlet weak var twoLb: UILabel! // 白布label 盖住 不显示
    
    @IBOutlet weak var priceLbOne: UILabel!// 第一个 价格
    @IBOutlet weak var priceLbTwo: UILabel!// 第二个 价格
    
    @IBOutlet weak var lbTitleOne: UILabel!// 第一个 标题
    @IBOutlet weak var lbTitleTwo: UILabel!// 第二个 标题
    
    @IBOutlet weak var imgShowOne: UIImageView!// 第一个 展示图片
    @IBOutlet weak var imgShowTwo: UIImageView!// 第二个 展示图片
    
    @IBOutlet weak var btnIsLikeOne: UIButton!// 1.是否喜欢的btn
    @IBOutlet weak var btnIsLikeTwo: UIButton!// 2.是否喜欢的btn
    
    @IBOutlet weak var lbNewOne: UILabel!// 1.第一个是否新品
    
    @IBOutlet weak var lbNewTwo: UILabel!
    @IBOutlet weak var lbDiscountOne: UILabel!// 1.第一个折扣
    
    @IBOutlet weak var lbDiscountTwo: UILabel!
    @IBOutlet weak var lbPromoteOne: UILabel!// 1.第一个 促销标题
    @IBOutlet weak var lbPromoteTwo: UILabel!
    
    @IBOutlet weak var lbStockOne: UILabel!// 1.第一个 售馨标签
    @IBOutlet weak var lbStockTwo: UILabel!
    
    @IBOutlet weak var LeftConstraintOne: NSLayoutConstraint! // 标签位置
    @IBOutlet weak var LeftConstraintTwo: NSLayoutConstraint!
    
    @IBOutlet weak var bottomConstraintOne: NSLayoutConstraint! // 标签、喜欢、距离底部距离
    @IBOutlet weak var bottomConstraintTwo: NSLayoutConstraint!
  
    var oneModel : WOWProductModel?
    
    var twoModel : WOWProductModel? = nil
    
    
    var productIdOne : Int?
    var productIdTwo : Int?
    
    func set_sold_out_status(label: UILabel){
        label.borderRadius(28)
        label.isHidden = false
    }
    
    func showDataOne(_ model:WOWProductModel) {
        oneModel = model
        
        if model.productStock == 0 {// 以售馨展示
            set_sold_out_status(label: lbStockOne)
        }else {
            lbStockOne.isHidden = true
        }
        
        imgShowOne.set_webimage_url(model.productImg)
        lbTitleOne.text     = model.productName
        productIdOne        = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalprice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
            if originalPrice > model.sellPrice {
                priceLbOne.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
            }else{
                priceLbOne.text = sellPrice
            }
            
        }else{
            priceLbOne.text = sellPrice
        }
        if WOWUserManager.loginStatus {
            if (model.favorite == true) {
                
                btnIsLikeOne.isSelected = true
                
            }else{
                
                btnIsLikeOne.isSelected = false
                
            }
            
        }else{
            btnIsLikeOne.isSelected = false
        }
        
        self.isHidden(lbNew: lbNewOne, lbDiscount: lbDiscountOne, lbPromote: lbPromoteOne,model: model)
    }
    /// 是否隐藏三个标签
    ///
    /// - parameter lbNew:      是否新品标签
    /// - parameter lbDiscount: 是否折扣标签
    /// - parameter lbPromote:  冬日促销标签
    /// - parameter model:      对应model
    /// - parameter isOne:      是否第一个Item
    func isHidden(lbNew: UILabel,lbDiscount: UILabel,lbPromote: UILabel,model:WOWProductModel,isOne:Bool = true)  {
        lbDiscount.text             = ""
        lbNew.isHidden              = true
        lbDiscount.isHidden         = true
        lbPromote.isHidden          = true
        //        if let discount = model.discount {
        //            lbDiscount.isHidden  = false
        //            lbDiscount.text      = (discount + "折").get_formted_Space()
        //        }
        for singModel in model.sings ?? []{
            switch singModel.id ?? 0{
            case 4:
                lbPromote.isHidden  = false
                lbPromote.text      = singModel.desc?.get_formted_Space()
            case 3:
                lbNew.isHidden      = false
            case 2:
                lbDiscount.isHidden = false
                lbDiscount.text     = ((singModel.desc ?? "") + "折").get_formted_Space()
            default: break
            }
        }
        if lbDiscount.isHidden && !lbPromote.isHidden{
            if isOne {
                self.LeftConstraintOne.constant = 0
            }else{
                self.LeftConstraintTwo.constant = 0
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    func setup() {
        _ = Bundle.main.loadNibNamed("Cell_ProjectSelect_View", owner: self, options: nil)?.last
        
        self.addSubview(self.view)
        self.view.frame = self.bounds
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
