//
//  HomeBrannerCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/5.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol HomeBrannerDelegate:class {
    func gotoVCFormLinkType(model: WOWCarouselBanners)
}
class HomeBrannerCell: UITableViewCell,ModuleViewElement,CyclePictureViewDelegate {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 101 // 今日商品推荐
    }
   var bannerCurrentArray = [WOWCarouselBanners]() //顶部轮播图数组
     weak var delegate : HomeBrannerDelegate?
    var imageURLArray: [String] = []
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    @IBOutlet weak var AspectRatioConstraint: NSLayoutConstraint! // 比例
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
      var heightAll:CGFloat = MGScreenWidth
    func reloadBanner(_ dataArr:[WOWCarouselBanners]){
        imageURLArray = []
        for i in 0..<dataArr.count {
            imageURLArray.append(dataArr[i].bannerImgSrc! as String)
        }
        bannerCurrentArray = dataArr
        cyclePictureView.delegate = self
        cyclePictureView.showPageControl = true
        cyclePictureView.currentDotColor = UIColor.black
        cyclePictureView.otherDotColor =   UIColor(hexString: "000000", alpha: 0.2)!
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.placeholderImage = UIImage.init(named: product)
        cyclePictureView.timeInterval = 3
     
    }
    
    public func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let model = bannerCurrentArray[(indexPath as NSIndexPath).row]
        
        if let del = delegate{
            del.gotoVCFormLinkType(model: model)
        }
//        let viewController = self.vc as! WOWBaseModuleVC
//        viewController.goController(model)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
