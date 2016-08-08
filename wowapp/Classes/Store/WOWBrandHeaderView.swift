//
//  WOWBrandHeaderView.swift
//  wowapp
//
//  Created by 安永超 on 16/8/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol brandHeaderViewDelegate: class {
    func moreClick()
}

class WOWBrandHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandDescLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    
    weak var delegate: brandHeaderViewDelegate?
    
    //显示品牌信息
    func showBrandData(model: WOWBrandV1Model) {
       
        logoImage.layer.cornerRadius = 40
        logoImage.layer.masksToBounds = true
        logoImage.kf_setImageWithURL(NSURL(string: model.image), placeholderImage: UIImage(named: "placeholder_product"))
        brandNameLabel.text = model.brandEname ?? ""
        let str = NSMutableAttributedString(string: model.desc ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        brandDescLabel.attributedText = str

    }
    
    //显示设计师信息
    func showDesignerData(model: WOWDesignerModel) {
        
        logoImage.layer.cornerRadius = 40
        logoImage.layer.masksToBounds = true
        logoImage.kf_setImageWithURL(NSURL(string: model.designerPhoto), placeholderImage: UIImage(named: "placeholder_product"))
        brandNameLabel.text = model.designerName ?? ""
        let str = NSMutableAttributedString(string: model.designerDesc ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        brandDescLabel.attributedText = str
        
    }
    
    @IBAction func moreButtonClick(sender: UIButton!) {
        if let del = delegate {
            del.moreClick()
        }
    }

}
