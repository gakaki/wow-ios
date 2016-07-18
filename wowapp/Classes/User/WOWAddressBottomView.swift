//
//  WOWAddressBottomView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAddressBottomView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    weak var leftLabel: UILabel!

    weak var rightButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func setUP(){
//        leftLabel = UILabel()
//        leftLabel.text = "新增地址"
//        leftLabel.textColor = UIColor.blackColor()
//        leftLabel.font = Fontlevel001
//        addSubview(leftLabel)
//        leftLabel.snp_makeConstraints { [weak self](make) in
//            if let strongSelf = self{
//                make.left.equalTo(strongSelf).offset(15)
//                make.top.bottom.equalTo(strongSelf).offset(0)
//            }
//        }
//        
//        rightButton = UIButton(type: .System)
//        rightButton.setTitle("+", forState:.Normal)
//        rightButton.setTitleColor(GrayColorlevel3, forState:.Normal)
//        addSubview(rightButton)
//        rightButton.snp_makeConstraints {[weak self](make) in
//            if let strongSelf = self{
//                make.right.equalTo(15)
//                make.top.bottom.equalTo(<#T##other: CGFloat##CGFloat#>)
//            }
//        }
//        
//    }
    
}
