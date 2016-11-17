
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

    let identifier = "WOWTypeCollectionCell"
    var typeArr = [String]()
    var model:WOWCarProductModel!
    weak var delegate: orderCarDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        tagList.textFont = UIFont.systemFont(ofSize: 10)

        // Initialization code
    }
    
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(_ model:WOWCarProductModel?) {
        guard let model = model else{
            return
        }
        self.model = model
//        goodsImageView.kf_setImageWithURL(NSURL(string:model.specImg ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        
        goodsImageView.set_webimage_url(model.specImg)
        
        nameLabel.text = model.productTitle
        countLabel.text = "x \(model.productQty ?? 0)"
        perPriceLabel.text = String(format: "¥ %.2f", (model.sellPrice) ?? 0)
        //productStatus -1已失效  2已下架  1并且库存等于0  已售罄
        
        if model.productStatus == -1 {
            statusLabel.text = "已失效"
        }else if model.productStatus == 2 {
            statusLabel.text = "已下架"
        }else if model.productStatus == 1 && model.productStock == 0 {
            statusLabel.text = "已售罄"
        }else {
            statusLabel.text = "已售罄"
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
