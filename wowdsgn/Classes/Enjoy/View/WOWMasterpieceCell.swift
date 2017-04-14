//
//  WOWMasterpieceCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceCell: UITableViewCell {

    @IBOutlet weak var imgWroks: UIImageView!
    @IBOutlet weak var thumbImg: UIImageView!
    var model: WOWFineWroksModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapClick(tap:)))
        singleTap.numberOfTapsRequired = 1
        
        imgWroks.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapClick(tap:)))
        doubleTap.numberOfTapsRequired = 2
        imgWroks.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
        
    }
    

    func showData(_ m : WOWFineWroksModel)  {
        model = m
        imgWroks.set_webimage_url(m.pic ?? "")

    }
    //单击手势事件
    func singleTapClick(tap: UITapGestureRecognizer)  {
        VCRedirect.bingWorksDetails(worksId: model?.id ?? 0)
    }
    //双击手势事件
    func doubleTapClick(tap: UITapGestureRecognizer)  {
        guard WOWUserManager.loginStatus == true else{
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        requestLike(works: model?.id ?? 0)
        imgWroks.isUserInteractionEnabled = false
        thumbImg.isHidden = false
        thumbImg.alpha = 0
        thumbImg.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {[unowned self] in
            self.thumbImg.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.thumbImg.alpha = 1
        }) { (finish) in
            
        }
        UIView.animate(withDuration: 1/8, delay: 7/8, options: .curveLinear, animations: { [unowned self] in
            self.thumbImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.thumbImg.alpha = 0
        }) { [unowned self](finish)  in
            self.thumbImg.isHidden = true
            self.imgWroks.isUserInteractionEnabled = true
        }
    }
    //喜欢某个作品
    func requestLike(works worksId: Int) {

        WOWNetManager.sharedManager.requestWithTarget(.api_LikeWorks(worksId: worksId, type: 1), successClosure: { (result, code) in
            WOWHud.dismiss()
            
        }) { (errorMsg) in
            WOWHud.dismiss()
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
