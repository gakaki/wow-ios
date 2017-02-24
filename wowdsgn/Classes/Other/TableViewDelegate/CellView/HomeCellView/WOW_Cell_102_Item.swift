//
//  WOW_Cell_103_Item.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/10/20.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOW_Cell_102_Item: UICollectionViewCell {
    @IBOutlet var bigImageView: UIImageView!
//    @IBOutlet weak var lbProductTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func showData(_ model:WOWCarouselBanners)  {
        
        let url = model.bannerImgSrc ?? ""
        bigImageView.set_webimage_url(url);
//        lbProductTitle.text = model.bannerTitle ?? ""
    }
}
