//
//  WOWBrandHeaderView.swift
//  wowapp
//
//  Created by 安永超 on 16/8/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol brandHeaderViewDelegate: class {
    func moreClick(_ sender: UIButton!)
}

class WOWBrandHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var brandDescLabel: UILabel!
    @IBOutlet weak var downButton: UIButton!
    
    weak var delegate: brandHeaderViewDelegate?
    
    //显示品牌信息
    func showBrandData(_ model: WOWBrandV1Model) {
       
        logoImage.layer.cornerRadius = 40
        logoImage.layer.masksToBounds = true
        loadImage.set_webimage_url( model.image )
        
        brandNameLabel.text = model.brandEname ?? ""
        brandDescLabel.text = model.desc ?? ""
        brandDescLabel.setLineHeightAndLineBreak(1.5)
    }
    
    //显示设计师信息
    func showDesignerData(_ model: WOWDesignerModel) {
        
        logoImage.layer.cornerRadius = 40
        logoImage.layer.masksToBounds = true
        loadImage.set_webimage_url( model.designerPhoto )

        brandNameLabel.text = model.designerName ?? ""
        brandDescLabel.text = model.designerDesc ?? ""
        brandDescLabel.setLineHeightAndLineBreak(1.5)
    }
    
    @IBAction func moreButtonClick(_ sender: UIButton!) {
        if let del = delegate {
            del.moreClick(sender)
        }
    }

}
