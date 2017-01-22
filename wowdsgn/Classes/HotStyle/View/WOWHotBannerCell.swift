//
//  WOWHotBannerCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol HotBrannerCellDelegate:class {
    func gotoVCFormLinkType_HotBanner(model: WOWCarouselBanners)
}
class WOWHotBannerCell: UITableViewCell,ModuleViewElement,CyclePictureViewDelegate {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 103
    }
    var imageURLArray: [String] = []
    
    var bannerCurrentArray = [WOWCarouselBanners]() //顶部轮播图数组
    weak var delegate : HotBrannerCellDelegate?
    
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
        bannerCurrentArray              = dataArr
        cyclePictureView.delegate       = self
        cyclePictureView.showPageControl = true
        cyclePictureView.currentDotColor = UIColor.black
        cyclePictureView.otherDotColor =   UIColor(hexString: "000000", alpha: 0.2)!
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.placeholderImage = UIImage(named: "placeholder_product")
        cyclePictureView.timeInterval = 3
        
    }
    
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let model = bannerCurrentArray[(indexPath as NSIndexPath).row]
        
        if let del = delegate{
            del.gotoVCFormLinkType_HotBanner(model: model)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
