
//
//  WOWOrderCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol orderCarDelegate: class {
    func toProductDetail(_ productId: Int?)
}

class WOWOrderCell: UITableViewCell {
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tagList: TagListView!

    var typeArr = [String]()
    var model:WOWCarProductModel!
    weak var delegate: orderCarDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(_ model:WOWCarProductModel?) {
        
        guard let model = model else{
            return
        }
        tagList.textFont = UIFont.systemFont(ofSize: 10)
        self.model = model        
        goodsImageView.set_webimage_url(model.specImg)
        
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 0)"
        perPriceLabel.text = String(format: "¥ %.2f", (model.sellPrice) ?? 0)
        //productStatus -1已失效  2已下架  1并且库存等于0  已售罄
       
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

        if let attributes = model.attributes {
            tagList.removeAllTags()
            for attribute in attributes {
                tagList.addTag(attribute)
            }

        }
        
        detailView.addTapGesture {[weak self] (tap) in
            if let strongSelf = self {
                if let del = strongSelf.delegate {
                    del.toProductDetail(model.productId)
                }
            }
            
        }
    
    }
    
    
}
