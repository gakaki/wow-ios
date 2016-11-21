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
    let identifier = "WOWTypeCollectionCell"
    var typeArr = [String]()
    var model:WOWCarProductModel!
    weak var delegate: buyCarDelegate?

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
        goodsImageView.set_webimage_url( model.specImg ?? "" )
        
        nameLabel.text = model.productTitle
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
                tagList.addTag("爱上了房间八日额偶飞吧几点上班阿里山的积分八点就开放")
                tagList.addTag("爱上了房间八日额偶飞吧几点上班阿里山的积分八点就开放")
                tagList.addTag("爱上了房间八日额偶飞吧几点上班阿里山的积分八点就开放")

            }
        }
        
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
