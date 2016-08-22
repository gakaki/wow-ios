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
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = productModel?.brandId 
        vc.entrance = .brandEntrance
        vc.hideNavigationBar = true
        UIApplication.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func designerClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.designerId = productModel?.designerId
        vc.entrance = .designerEntrance
        vc.hideNavigationBar = true
        UIApplication.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showData(model:WOWProductModel?){
        productModel = model
        brandNameLabel.text = model?.brandCname
        let str = NSMutableAttributedString(string: model?.sellingPoint ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        style.alignment = .Center
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        descLabel.attributedText = str
        brandButton.kf_setBackgroundImageWithURL(NSURL(string:model?.brandLogoImg ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
        guard let designerName = model?.designerName where !designerName.isEmpty else{
            designerContainerView.hidden = true
            brandContainerRightConstraint.priority = 250;
            return
        }
        designerNameLabel.text = designerName
        designerButton.kf_setBackgroundImageWithURL(NSURL(string: model?.designerPhoto ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
    }
}
