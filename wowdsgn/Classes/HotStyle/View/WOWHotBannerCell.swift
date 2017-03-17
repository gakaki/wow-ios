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
    
    var bannerCurrentArray = [WOWCarouselBanners](){
        didSet{
 
            
            itemHight = WOWArrayAddStr.get_img_sizeNew(str: imageURLArray[0], width: MGScreenWidth, defaule_size: .ThreeToTwo)

            
            hightConstraint.constant = itemHight// 总高度
            
            
            
        }

    } //顶部轮播图数组
    
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    
    var rate:CGFloat = 2/3 // 宽高比
    
    var moduleId: Int! = 0
    var pageTitle: String! = ""
    var itemHight : CGFloat = 100
    
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
        cyclePictureView.currentDotColor = UIColor.init(hexString: "#202020")!
        cyclePictureView.otherDotColor  =   UIColor.white
        cyclePictureView.showShadowView = true
        cyclePictureView.imageURLArray  = imageURLArray
        cyclePictureView.placeholderImage = UIImage(named: "placeholder_product")
        cyclePictureView.timeInterval = 5
        
    }
    
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let model = bannerCurrentArray[(indexPath as NSIndexPath).row]
        
        if let del = delegate{
            //Mob 轮播模块
            let position = String(format: "%i_%@_%i", moduleId, pageTitle, indexPath.row )
            let bannerId = String(format: "%i_%@_%i", moduleId, pageTitle, model.id ?? 0)
            let bannerName = String(format: "%i_%@_%@", moduleId, pageTitle, model.bannerTitle ?? "")
            let params = ["ModuleID_Secondary_Homepagename_Position": position, "ModuleID_Secondary_Homepagename_Banner_ID": bannerId, "ModuleID_Secondary_Homepagename_Banner_Name": bannerName]
            MobClick.e2(.Slide_Banners_Clicks, params)

            del.gotoVCFormLinkType_HotBanner(model: model)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
