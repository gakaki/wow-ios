//
//  WOWProductDetailDescCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailDescCell: UITableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var designerButton: UIButton!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var brandContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandBorderView: UIView!
    @IBOutlet weak var designerBorderView: UIView!
    @IBOutlet weak var brandContainerView: UIView!
    @IBOutlet weak var designerContainerView: UIView!
    
    var productModel:WOWProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        WOWBorderColor(brandBorderView)
        WOWBorderColor(designerBorderView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    @IBAction func brandClick(sender: UIButton) {
        DLog("调到品牌去")
    }
    @IBAction func designerClick(sender: UIButton) {
        DLog("调到设计师去")
    }
    
    func showData(model:WOWProductModel?){
        productModel = model
        brandNameLabel.text = model?.brandName
        descLabel.text      = model?.productShortDes
        brandButton.kf_setBackgroundImageWithURL(NSURL(string:model?.brandImage ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
        guard let designerName = model?.designer_name where !designerName.isEmpty else{
            designerContainerView.hidden = true
            brandContainerRightConstraint.priority = 250;
            return
        }
        designerNameLabel.text = designerName
        designerButton.kf_setBackgroundImageWithURL(NSURL(string: model?.designer_url ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
    }
}
