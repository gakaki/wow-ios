//
//  WOWHotBannerCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWHotBannerCell: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 103
    }
    var imageURLArray: [String] = []
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func reloadBanner(_ dataArr:[WOWCarouselBanners]){
        imageURLArray = []
        for i in 0..<dataArr.count {
            imageURLArray.append(dataArr[i].bannerImgSrc ?? "" as String)
        }
        
        cyclePictureView.showPageControl = true
        cyclePictureView.currentDotColor = UIColor.black
        cyclePictureView.otherDotColor =   UIColor(hexString: "000000", alpha: 0.2)!
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.placeholderImage = UIImage(named: "placeholder_product")
        cyclePictureView.timeInterval = 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
