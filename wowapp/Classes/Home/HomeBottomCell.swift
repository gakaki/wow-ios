//
//  HomeBottomCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class HomeBottomCell: UITableViewCell {
    
    var indexPath:NSIndexPath!
    var currentIndexPath : Int = 0
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

    
    @IBAction func clickOneBtn(sender: AnyObject) {
        print("==\(sender.tag)")
     
    }
    @IBAction func clickTwoBtn(sender: AnyObject) {
         print("==\(sender.tag)")

    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func showDataOne(model:WOWFoundProductModel) {

    self.imgShowOne.kf_setImageWithURL(NSURL(string: model.productImg ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        lbTitleOne.text = model.productName
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalPrice {
              originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ?? 0],counts:[1])
        }
       
        // 格式化富文本
        priceLbOne.strokeWithText(sellPrice ?? "", str2: originalPriceStr ?? "", str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
        
    }
    func showDataTwo(model:WOWFoundProductModel) {
        
        self.imgShowTwo.kf_setImageWithURL(NSURL(string: model.productImg ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
        lbTitleTwo.text = model.productName
        // 格式化 价格小数点
        let sellPrice = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        var originalPriceStr = ""
        if let originalPrice = model.originalPrice {
            originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ?? 0],counts:[1])
        }
        
         // 格式化富文本
        priceLbTwo.strokeWithText(sellPrice ?? "", str2: originalPriceStr ?? "", str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
        
    }
    func price(sellPrice:Double , originalPrice:Double) -> Array<String> {
        
        let sellPrice = WOWCalPrice.calTotalPrice([sellPrice ?? 0],counts:[1])
        
        let originalPriceStr =  WOWCalPrice.calTotalPrice([originalPrice ?? 0],counts:[1])
        
        return [sellPrice,originalPriceStr]
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
