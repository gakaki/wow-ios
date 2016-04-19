//
//  WOWlListCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol SenceCellDelegate:class{
    func senceProductClick(produtID:String)
}

class WOWlListCell: UITableViewCell {
    
    @IBOutlet var bigImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    private var productBtns = [UIButton]()
    weak var delegate:SenceCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(model:WOWSenceModel) {
        let url = model.senceImage ?? ""
        bigImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage:UIImage(named:"squarePlaceHoder"))
        dateLabel.text = model.senceTime
        titleLabel.text = model.senceName
        
        productBtns.forEach { (view) in
            view.removeFromSuperview()
        }
        bigImageView.userInteractionEnabled = true
        let products = model.senceProducts ?? []
        productBtns = []
        for productModel in products {
            let btn = UIButton(type: .System)
            btn.setImage(UIImage(named: "sence_animatePot")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
            btn.tag = Int(productModel.productID ?? "-1111") ?? -1111
            btn.addTarget(self, action:#selector(productBtnClick(_:)) , forControlEvents:.TouchUpInside)
            if let X = productModel.productX,Y = productModel.productY {
                let frame = self.convertRect(CGRectMake(CGFloat(X),CGFloat(Y), 40, 40), fromView: bigImageView)
                btn.frame = frame
                self.addSubview(btn)
                self.productBtns.append(btn)
                UIView.animateWithDuration(1, delay: 0, options: [.Repeat, .Autoreverse,.AllowUserInteraction], animations: { 
                    btn.layer.transform = CATransform3DMakeScale(1.4, 1.4, 1)
                }, completion: { (ret) in
                        
                })
            }
        }
    }
    
    func click() {
        DLog("123")
    }
    
    func productBtnClick(sender:UIButton) {
        guard sender.tag != -1111 else{
            return
        }
        if let del = delegate {
            del.senceProductClick(String(sender.tag))
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
    
//    func stopAnimate() {
//        let btns = bigImageView.subviews
//        btns.forEach { (view) in
//            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveLinear], animations: { 
//                view.alpha = 0
//                view.layer.removeAllAnimations()
//            }, completion: { (ret) in
//                        
//            })
//        }
//    }
}
