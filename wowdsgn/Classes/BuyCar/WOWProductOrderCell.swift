//
//  WOWProductOrderCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/18.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductOrderCell: UITableViewCell{

    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var subCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tagList: TagListView!

    var typeArr = [String]()
    var model:WOWCarProductModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(_ model:WOWCarProductModel?) {
        tagList.textFont = UIFont.systemFont(ofSize: 10)
        guard let model = model else{
            return
        }
        self.model = model
        //        goodsImageView.kf_setImageWithURL(NSURL(string:model.specImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        
        switch model.productStatus ?? 1{
        case -1:
            statusLabel.isHidden = false
            statusLabel.text = "已失效"
        case 2:
            statusLabel.isHidden = false
            statusLabel.text = "已下架"
        case 1:
            if model.productStock == 0 {
                statusLabel.isHidden = false
                statusLabel.text = "已售罄"
            }else {
                statusLabel.isHidden = true
                statusLabel.text = ""
            }
        default:
            statusLabel.isHidden = true
            statusLabel.text = ""
            
        }
        goodsImageView.set_webimage_url(model.specImg)
        
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 1)"
        subCountLabel.text = "共\(model.productQty ?? 1)件"
        let result1 = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        perPriceLabel.text = result1
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[model.productQty ?? 1])
        totalPriceLabel.text = result
        if let attributes = model.attributes {
            tagList.removeAllTags()
            for attribute in attributes {
                tagList.addTag(attribute)
            }
        }

        
    }
    

}
