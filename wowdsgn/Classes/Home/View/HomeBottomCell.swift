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
    func goToProductDetailVC(_ indexRow: Int?)
    
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
    
     @IBOutlet weak var btnIsLikeOne: UIButton!// 是否喜欢的btn
    @IBOutlet weak var btnIsLikeTwo: UIButton!// 是否喜欢的btn

    
    @IBAction func clickOneBtn(_ sender: AnyObject) {

        if let del = delegate{
     
            del.goToProductDetailVC(sender.tag)

        }
     
    }
    @IBAction func clickTwoBtn(_ sender: AnyObject) {
        
        if let del = delegate{
            
            del.goToProductDetailVC(sender.tag)
            
        }


    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    @IBAction func favoriteActionOne(_ sender: AnyObject) {
        WOWHud.showLoadingSV()
        
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdOne ?? 0,view: oneBaseView,btn: btnIsLikeOne , isFavorite: { (isFavorite) in
            
            print("完成请求")
   
        })

    }
    @IBAction func favoriteActionTwo(_ sender: AnyObject) {
        WOWHud.showLoadingSV()
        WOWClickLikeAction.requestFavoriteProduct(productId: productIdTwo ?? 0,view: twoBaseView,btn: btnIsLikeTwo, isFavorite: { (isFavorite) in

            print("完成请求")
            
        })

        
    }

    func showDataOne(_ model:WOWFoundProductModel) {

        imgShowOne.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        lbTitleOne.text = model.productName
        productIdOne = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalPrice {
              originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
        }
        // 格式化富文本
        priceLbOne.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)

     
        if WOWUserManager.loginStatus {
            if (model.favorite == true) {

                btnIsLikeOne.isSelected = true
                
            }else{
                
                btnIsLikeOne.isSelected = false
                
            }

        }else{
            btnIsLikeOne.isSelected = false
        }
     
    
        
    }
    func showDataTwo(_ model:WOWFoundProductModel) {

        imgShowTwo.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        lbTitleTwo.text = model.productName
        productIdTwo = model.productId
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalPrice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])
        }
        // 格式化富文本
        priceLbTwo.strokeWithText(sellPrice , str2: originalPriceStr , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)

     
        if WOWUserManager.loginStatus {
        if (model.favorite == true) {
            
            btnIsLikeTwo.isSelected = true
            
        }else{
            
            btnIsLikeTwo.isSelected = false

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
