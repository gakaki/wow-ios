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
    var bannerCurrentArray = [WOWCarouselBanners](){//顶部轮播图数组
        didSet{
            
//            rate = CGFloat(WOWArrayAddStr.get_img_size(str: imageURLArray[0] ))// 拿到图片的宽高比
            
            itemHight = WOWArrayAddStr.get_img_sizeNew(str: imageURLArray[0], width: MGScreenWidth, defaule_size: .OneToOne)
//            itemHight = MGScreenWidth * rate // 计算此Item的高度
            
            hightConstraint.constant = itemHight// 总高度
            
            
            
        }

    }
    
    weak var delegate : HomeBrannerDelegate?
    
    var imageURLArray = [String]()
        
    
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    @IBOutlet weak var AspectRatioConstraint: NSLayoutConstraint! // 比例
    
    @IBOutlet weak var hightConstraint: NSLayoutConstraint!
    
    var rate:CGFloat = 1/1 // 宽高比
    
    
    var itemHight : CGFloat = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var heightAll:CGFloat = MGScreenWidth
    func reloadBanner(_ dataArr:[WOWCarouselBanners]){
        imageURLArray = []
        for i in 0..<dataArr.count {
            imageURLArray.append((dataArr[i].bannerImgSrc ?? "") as String)
        }
        bannerCurrentArray = dataArr
        cyclePictureView.delegate = self
        cyclePictureView.showPageControl = true
        cyclePictureView.currentDotColor = UIColor.init(hexString: "#202020")!
        cyclePictureView.otherDotColor =   UIColor.white
        cyclePictureView.showShadowView = true
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.placeholderImage = UIImage.init(named: product)
        cyclePictureView.timeInterval = 5
     
    }
    
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
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
