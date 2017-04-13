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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        tap.numberOfTapsRequired = 2
        imgWroks.addGestureRecognizer(tap)
    }


    func showData(_ m : WOWFineWroksModel)  {
        
        imgWroks.set_webimage_url(m.pic ?? "")
//        VCRedirect.bingWorksDetails(worksId: m.id ?? 0)

    }
    
    func tapClick(tap: UITapGestureRecognizer)  {
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
