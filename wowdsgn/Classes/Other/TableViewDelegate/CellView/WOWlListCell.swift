//
//  WOWlListCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import YYWebImage

protocol SenceCellDelegate:class{
    func senceProductClick(_ produtID:Int)
}

class WOWlListCell: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 201 // 单条图片cell
    }
    @IBOutlet weak var imgRationConstraints: NSLayoutConstraint!
    @IBOutlet var bigImageView: UIImageView!
    var model : WOWCarouselBanners?{
        didSet{
            
            rate = CGFloat(WOWArrayAddStr.get_img_size_withThreeTwo(str: model?.bannerImgSrc ?? ""))// 拿到图片的宽高比,
            
            itemHight = MGScreenWidth * rate // 计算此Item的高度
            
            imgRationConstraints.constant = itemHight

        }
    }
    var rate:CGFloat = 2/3 // 宽高比
    
    
    var itemHight : CGFloat = 100
    
    fileprivate var productBtns = [UIButton]()
    var heightAll:CGFloat = MGScreenWidth * 0.66

    weak var delegate:SenceCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(_ model:WOWCarouselBanners) {
        let url = model.bannerImgSrc ?? ""
        DLog(url)
        bigImageView.set_webimage_url(url)
        
        productBtns.forEach { (view) in
            view.removeFromSuperview()
        }
        bigImageView.isUserInteractionEnabled = true
    }

    func productBtnClick(_ sender:UIButton) {
        guard sender.tag != -1111 else{
            return
        }
        if let del = delegate {
            del.senceProductClick(sender.tag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    func startAnimate() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse,.allowUserInteraction], animations: {
            self.productBtns.forEach({ (view) in
                view.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1)
            })
        }) { (ret) in
                
        }
    }
}


//单条 201 banner
//extension WOWlListCell:ModuleViewElement{
//    static func isNib() -> Bool { return true }
//    static func cell_type() -> Int { return 201 }
//    func setData(_ model:WowModulePageItemVO) {
//        let url = model.bannerImgSrc ?? ""
//        DLog(url)
//        bigImageView.set_webimage_url(url);
//        
//        productBtns.forEach { (view) in
//            view.removeFromSuperview()
//        }
//        bigImageView.isUserInteractionEnabled = true
//
//    }
//}
