//
//  WOWDSGNFooterView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/29.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWDSGNFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
    
        self.backgroundColor = UIColor.white
        
        let img = UIImageView()
        img.image = UIImage(named: "wowdsgn")
        self.addSubview(img)
        img.snp.makeConstraints { [weak self](make) -> Void in
            make.width.equalTo(97)
            make.height.equalTo(10)
            make.center.equalTo(self!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class WOWHearderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.white
        
        let img = UIImageView()
        img.image = UIImage(named: "recommend")
        self.addSubview(img)
        img.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self{
                make.width.equalTo(137)
                make.height.equalTo(37)
                make.center.equalTo(strongSelf)
            }
        }
        let lbBottom = UILabel.initLable(" ", titleColor: UIColor.black, textAlignment: .center, font: 10)
        lbBottom.backgroundColor = UIColor.init(hexString: "eaeaea")
        self.addSubview(lbBottom)
        lbBottom.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self{
                make.width.equalTo(strongSelf)
                make.height.equalTo(0.5)
                make.left.equalTo(strongSelf)
                make.bottom.equalTo(strongSelf).offset(0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

