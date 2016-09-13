//
//  WOWHotStyleCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHotStyleCell: UITableViewCell {

    @IBOutlet weak var lbLogoName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbPraise: UILabel!
    @IBOutlet weak var lbTitleMain: UILabel!
    @IBOutlet weak var lbBrowse: UILabel!
    @IBOutlet weak var imgBackMain: UIImageView!
    var brandModel : WOWBrandStyleModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(model: WOWHomeModle)  {
        
        if let brandModel = model.moduleContentList?.brand {
            
            lbLogoName.text = brandModel.brandEname
            imgLogo.set_webimage_url_base(brandModel.brandLogoImg, place_holder_name: product)
            
        }else{
            lbLogoName.text = " "
            imgLogo.image = nil
        }
        if let moduleImage = model.moduleImage {
            
            imgBackMain.set_webimage_url_base(moduleImage, place_holder_name: product)
        }
       
        if let modultTitle = model.moduleTitle {
            lbTitleMain.text = modultTitle
           
        
        }
            lbBrowse.text =   model.moduleContentList?.likeQty?.toString
        
            lbPraise.text = model.moduleContentList?.readQty?.toString

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
