//
//  WOWBuyCarNormalCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol buyCarDelegate: class {
    func goProductDetail(_ productId: Int?)
}

class WOWBuyCarNormalCell: UITableViewCell{

    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCountButton: UIButton!
    @IBOutlet weak var addCountButton: UIButton!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var limitView: UIView!
    @IBOutlet weak var limitTagLabel: UILabel!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    var typeArr = [String]()
    var model:WOWCarProductModel!
    weak var delegate: buyCarDelegate?

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
        goodsImageView.set_webimage_url( model.specImg ?? "" )
        
        nameLabel.text = model.productName
        countLabel.text = "x \(model.productQty ?? 1)"
        countTextField.text = "\(model.productQty ?? 1)"
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        perPriceLabel.text = result
        selectButton.isSelected = model.isSelected ?? false
//        let arr = [model.color ?? "",model.specName ?? ""]
        if let attributes = model.attributes {
            tagList.removeAllTags()
            for attribute in attributes {
                tagList.addTag(attribute)
            }
        }
        //判断产品是否是促销产品,如果是促销产品的话打上标签
        if model.limitQty > 0 {
            topHeight.constant = 30
            limitView.isHidden = false
            limitTagLabel.text = model.pricePromotionTag ?? ""
        }else {
            topHeight.constant = 15
            limitView.isHidden = true
            limitTagLabel.text = ""
        }
        //判断产品数量和库存状态
        if model.productQty < model.productStock {
            addCountButton.isEnabled = true
            addCountButton.setTitleColor(UIColor.black, for: UIControlState())
        }else {
            addCountButton.isEnabled = false
            addCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
        }
        if model.productQty! <= 1 {
            subCountButton.isEnabled = false
            subCountButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
        }else {
            subCountButton.isEnabled = true
            subCountButton.setTitleColor(UIColor.black, for: UIControlState())
        }
        detailView.addTapGesture {[weak self] (tap) in
            if let strongSelf = self {
                if let del = strongSelf.delegate {
                    del.goProductDetail(model.productId)
                }
            }
            
        }
       
    }

 
}
