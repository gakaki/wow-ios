//
//  WOWChoiseClassCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWChoiseClassCell: UICollectionViewCell {

    @IBOutlet weak var imgClassIcon: UIImageView!
    
    @IBOutlet weak var lbClassName: UILabel!
    
    @IBOutlet weak var imgChoiseSelect: UIImageView!
    @IBOutlet weak var lbClassSubTittles: UILabel!
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
        imgClassIcon.borderRadius(40)
        imgChoiseSelect.isHidden = true
        
    }
    
    func showData(_ m : WOWEnjoyCategoryModel)  {
        lbClassName.text = m.categoryName ?? ""
        lbClassSubTittles.text = m.title ?? ""
        if let img = m.pic{
             imgClassIcon.set_webimage_url(img)
        }else {
            imgClassIcon.image = UIImage.init(named: "placeholder_product")
        }
        if m.isSelect {

            imgChoiseSelect.isHidden = false
        }else {
            imgChoiseSelect.isHidden = true
        }
        
    }
}
