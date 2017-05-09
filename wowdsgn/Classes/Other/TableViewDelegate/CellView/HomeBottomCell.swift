//
//  HomeBottomCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
//  bottom cell 、 402 cell
protocol HomeBottomDelegate:class {
    // 跳转产品详情代理
    func goToProductDetailVC(_ productId: Int?)
    
    
}

class HomeBottomCell: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 402 // 今日商品推荐
    }
    var heightCell:CGFloat = 244.0
    var heightAll:CGFloat = CGFloat.leastNormalMagnitude
    weak var delegate : HomeBottomDelegate?
    @IBOutlet weak var oneBaseView: UIView!
    @IBOutlet weak var twoBaseView: UIView!
    
    var indexPath:IndexPath!
    var currentIndexPath : Int = 0
    var productIdOne : Int?
    var productIdTwo : Int?
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
    
    var moduleId: Int! = 0
    var pageTitle: String! = ""
    var moduleType: Int = 0     //如果为0是瀑布流，如果不为0则是纵向产品组
    
    var oneModel : WOWProductModel? = nil
    var twoModel : WOWProductModel? = nil
    
    @IBAction func clickOneBtn(_ sender: UIButton!) {
        
        if let del = delegate{
            let index: Int = sender.tag
            if moduleType == 402 {
                //Mob 纵向产品组模块 banner点击
                let productId = String(format: "%i_%@_%i", moduleId, pageTitle, oneModel?.productId ?? 0)
                let productName = String(format: "%i_%@_%@", moduleId, pageTitle, oneModel?.productName ?? "")
                let productPosition = String(format: "%i_%@_%i", moduleId, pageTitle, index)
                let params = ["ModuleID_Secondary_Homepagename_Productid": productId, "ModuleID_Secondary_Homepagename_Productname": productName, "ModuleID_Secondary_Homepagename_Productposition": productPosition]
                MobClick.e2(.Productlist_Portrait, params)
            }else {
                let productName = oneModel?.productName
                let productId = oneModel?.productId
                let params = ["productName": productName ?? "", "productId": productId ?? 0] as [String : Any]
                if pageTitle == "购物车" {
                    MobClick.e2(.product_recommend_shoppingcart_clicks, params)

                }else {

                    MobClick.e2(.product_recommend_clicks, params)
                }

            }

            
            del.goToProductDetailVC(oneModel?.productId)
        }
        
    }
    @IBAction func clickTwoBtn(_ sender: UIButton!) {
        
        if let del = delegate{
            let index: Int = sender.tag
            if moduleType == 402 {
                //Mob 纵向产品组模块 banner点击
                let productId = String(format: "%i_%@_%i", moduleId, pageTitle, twoModel?.productId ?? 0)
                let productName = String(format: "%i_%@_%@", moduleId, pageTitle, twoModel?.productName ?? "")
                let productPosition = String(format: "%i_%@_%i", moduleId, pageTitle, index)
                let params = ["ModuleID_Secondary_Homepagename_Productid": productId, "ModuleID_Secondary_Homepagename_Productname": productName, "ModuleID_Secondary_Homepagename_Productposition": productPosition]
                MobClick.e2(.Productlist_Portrait, params)
            
            }else {
                let productName = twoModel?.productName
                let productId = twoModel?.productId
                let params = ["productName": productName ?? "", "productId": productId ?? 0] as [String : Any]
                if pageTitle == "购物车" {
                    
                    MobClick.e2(.product_recommend_shoppingcart_clicks, params)

                }else {

                    MobClick.e2(.product_recommend_clicks, params)
                }

            }
            
            del.goToProductDetailVC(twoModel?.productId)
            
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func favoriteActionOne(_ sender: AnyObject) {
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdOne ?? 0,view: oneBaseView,btn: btnIsLikeOne , isFavorite: { (isFavorite) in
            
            print("完成请求")
            
        })
        
    }
    @IBAction func favoriteActionTwo(_ sender: AnyObject) {
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdTwo ?? 0,view: twoBaseView,btn: btnIsLikeTwo, isFavorite: { (isFavorite) in
            
            print("完成请求")
            
        })
        
    }
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
    //   two Item Data
    func showDataTwo(_ model:WOWProductModel) {
        twoModel = model
        if model.productStock == 0 {// 以售馨展示
            set_sold_out_status(label: lbStockTwo)
        }else {
            lbStockTwo.isHidden = true
        }

        imgShowTwo.set_webimage_url(model.productImg)
        lbTitleTwo.text = model.productName
        productIdTwo = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalprice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
            if originalPrice > model.sellPrice {
             priceLbTwo.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
            }else{
                priceLbTwo.text = sellPrice
            }
           
        }else{
            priceLbTwo.text = sellPrice
        }
     
        if WOWUserManager.loginStatus {
            if (model.favorite == true) {
                
                btnIsLikeTwo.isSelected = true
                
            }else{
                
                btnIsLikeTwo.isSelected = false
                
            }
            
        }else {
              btnIsLikeTwo.isSelected = false
        }

        self.isHidden(lbNew: lbNewTwo, lbDiscount: lbDiscountTwo, lbPromote: lbPromoteTwo,model: model,isOne:false)
        
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
    
    func price(_ sellPrice:Double , originalPrice:Double) -> Array<String> {
        
        let sellPrice = WOWCalPrice.calTotalPrice([sellPrice ],counts:[1])
        
        let originalPriceStr =  WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
        
        return [sellPrice,originalPriceStr]
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
