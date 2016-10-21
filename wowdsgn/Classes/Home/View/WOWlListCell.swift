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

        bigImageView.set_webimage_url(url);

        
        
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
