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

class WOWlListCell: UITableViewCell {
    
    @IBOutlet var bigImageView: UIImageView!
    
    fileprivate var productBtns = [UIButton]()
    
    var heightAll:CGFloat   = MGScreenWidth
    
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
//      bigImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage:UIImage(named: "placeholder_product"))
        bigImageView.set_webimage_url(url);
//        bigImageView
//        
//        bigImageView.yy_setImageWithURL(NSURL(string: url)!, placeholder: "placeholder_product", options: nil, progress: {(receivedSize: Int, expectedSize: Int) -> Void in
//            let progress = Float(receivedSize) / expectedSize
//            }, transform: {(image: UIImage, url: NSURL) -> UIImage in
//                image = image.yy_imageByResizeToSize(CGSizeMake(100, 100), contentMode: .Center)
//                return image.yy_imageByRoundCornerRadius(10)
//            }, completion: {(image: UIImage, url: NSURL, from: YYWebImageFromType, stage: YYWebImageStage, error: NSError?) -> Void in
//                if from == YYWebImageFromDiskCache {
//                    print("load from disk cache")
//                }
//        })

        
        
        productBtns.forEach { (view) in
            view.removeFromSuperview()
        }
        bigImageView.isUserInteractionEnabled = true
//        let products = model.products ?? []
//        productBtns = []
//        for productModel in products {
//            let btn = UIButton(type: .System)
//            btn.setImage(UIImage(named: "sence_animatePot")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
//            btn.tag = Int(productModel.productID ?? "-1111") ?? -1111
//            btn.addTarget(self, action:#selector(productBtnClick(_:)) , forControlEvents:.TouchUpInside)
//            if let X = Float(productModel.productX ?? "0"),Y = Float(productModel.productY ?? "0") {
////                let px = CGFloat(X) * (self.w/100)
////                let py = CGFloat(Y) * (self.w/100)
////                let frame = CGRectMake(px,py, 40, 40)
//                let scale = CGFloat(1000) / MGScreenWidth
//                let frame = CGRectMake(0,0,40,40)
//                btn.frame = frame
//                self.bigImageView.addSubview(btn)
//                btn.center = CGPointMake(CGFloat(X * 10 / Float(scale)),CGFloat(Y * 10 / Float(scale)))
//                self.productBtns.append(btn)
//                UIView.animateWithDuration(1, delay: 0, options: [.Repeat, .Autoreverse,.AllowUserInteraction], animations: { 
//                    btn.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1)
//                }, completion: { (ret) in
//                        
//                })
//            }
//        }
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
extension WOWlListCell:ModuleViewElement{
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int { return 201 }
    func setData(_ model:WowModulePageItemVO) {
        let url = model.bannerImgSrc ?? ""
        DLog(url)
        bigImageView.set_webimage_url(url);
        
        productBtns.forEach { (view) in
            view.removeFromSuperview()
        }
        bigImageView.isUserInteractionEnabled = true

    }
}