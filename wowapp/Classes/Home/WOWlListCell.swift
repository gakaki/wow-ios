//
//  WOWlListCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol SenceCellDelegate:class{
    func senceProductClick(produtID:Int)
}

class WOWlListCell: UITableViewCell {
    
    @IBOutlet var bigImageView: UIImageView!

    private var productBtns = [UIButton]()
    weak var delegate:SenceCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showData(model:WOWCarouselBanners) {
        let url = model.bannerImgSrc ?? ""
      print(url)
        bigImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage:UIImage(named: "placeholder_product"))
     
        
        productBtns.forEach { (view) in
            view.removeFromSuperview()
        }
        bigImageView.userInteractionEnabled = true
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

    func productBtnClick(sender:UIButton) {
        guard sender.tag != -1111 else{
            return
        }
        if let del = delegate {
            del.senceProductClick(sender.tag)
        }
    }
    
    
    func startAnimate() {
        UIView.animateWithDuration(1, delay: 0, options: [.Repeat, .Autoreverse,.AllowUserInteraction], animations: {
            self.productBtns.forEach({ (view) in
                view.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1)
            })
        }) { (ret) in
                
        }
    }
}
