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

class HomeBottomCell: UITableViewCell {
    
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
    @IBOutlet weak var LeftConstraintOne: NSLayoutConstraint!
    @IBOutlet weak var LeftConstraintTwo: NSLayoutConstraint!
    var oneModel : WOWProductModel? = nil
    var twoModel : WOWProductModel? = nil
    
    @IBAction func clickOneBtn(_ sender: AnyObject) {
        
        if let del = delegate{
            
            del.goToProductDetailVC(oneModel?.productId)
            
        }
        
    }
    @IBAction func clickTwoBtn(_ sender: AnyObject) {
        
        if let del = delegate{
            
            del.goToProductDetailVC(twoModel?.productId)
            
        }
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func favoriteActionOne(_ sender: AnyObject) {
        //        WOWHud.showLoadingSV()
        
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdOne ?? 0,view: oneBaseView,btn: btnIsLikeOne , isFavorite: { (isFavorite) in
            
            print("完成请求")
            
        })
        
    }
    @IBAction func favoriteActionTwo(_ sender: AnyObject) {
        //        WOWHud.showLoadingSV()
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdTwo ?? 0,view: twoBaseView,btn: btnIsLikeTwo, isFavorite: { (isFavorite) in
            
            print("完成请求")
            
        })
        
        
    }
    
    func showDataOne(_ model:WOWProductModel) {
        oneModel = model
        imgShowOne.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        lbTitleOne.text = model.productName
        productIdOne = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalprice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
            if originalPrice > model.sellPrice {
                priceLbOne.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
            }

        }
        // 格式化富文本
        
        
        
        if WOWUserManager.loginStatus {
            if (model.favorite == true) {
                
                btnIsLikeOne.isSelected = true
                
            }else{
                
                btnIsLikeOne.isSelected = false
                
            }
            
        }else{
            btnIsLikeOne.isSelected = false
        }
        
        let discoutStr  = "5.5折"
        let labelStr    = "冬季促销"
        
        isHidden(lbNew: lbNewOne, lbDiscount: lbDiscountOne, lbPromote: lbPromoteOne, discountStr: discoutStr, promoteStr: labelStr,model: model)
        
        
    }
    //    originalprice
    func showDataTwo(_ model:WOWProductModel) {
        twoModel = model
        imgShowTwo.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        lbTitleTwo.text = model.productName
        productIdTwo = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalprice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
            if originalPrice > model.sellPrice {
             priceLbTwo.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
            }
           
        }
     
        
        
        if WOWUserManager.loginStatus {
            if (model.favorite == true) {
                
                btnIsLikeTwo.isSelected = true
                
            }else{
                
                btnIsLikeTwo.isSelected = false
                
            }
            
        }
        let discoutStr  = "5.5折"
        let labelStr    = "冬季促销"
        
        isHidden(lbNew: lbNewTwo, lbDiscount: lbDiscountTwo, lbPromote: lbPromoteTwo, discountStr: discoutStr, promoteStr: labelStr,model: model)
        
    }
    func isHidden(lbNew: UILabel,lbDiscount: UILabel,lbPromote: UILabel,discountStr:String,promoteStr:String,model:WOWProductModel)  {
        lbNew.isHidden = true
        //        lbDiscountOne.isHidden = true
        lbDiscount.text = discountStr.get_formted_Space()
        lbPromote.isHidden = true
        if model.tag?.isEmpty ?? false{
            
            lbPromote.text = model.tag?.get_formted_Space()
            
        }
        if let typeArray = model.sings{
            for type in typeArray{
                switch type {
                case 1:// 喜欢
//
                    break
                case 2:// 折扣
                    lbDiscount.text      = discountStr.get_formted_Space()
                    lbDiscount.isHidden = false
                case 3:// 新品
                    lbNew.isHidden = false
//                    lbPromote.text    = promoteStr.get_formted_Space()
//                    lbPromote.isHidden = false
//                    if lbDiscount.isHidden || lbDiscount.text?.isEmpty ?? false{
//                        LeftConstraintOne.constant = 0
//                    }
                default:
                    break
                }
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
