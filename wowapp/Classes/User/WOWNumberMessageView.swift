//
//  WOWNumberMessageView.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
//左边文字。  右边图片 
/// 这个是个人中心右上角的东东
class WOWNumberMessageView: UIView {
    var leftLabel = UILabel()
    var rightImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func configSubViews(){

        rightImageView.image = UIImage(named: "icon_message")
        addSubview(rightImageView)
        rightImageView.snp_makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.centerY.equalTo(strongSelf)
                make.right.equalTo(strongSelf)
            }
        }
        
        leftLabel.textColor = UIColor.black
        leftLabel.font = FontLevel005
        //FIXME:测试数据
        leftLabel.text = "1222"
        addSubview(leftLabel)
        leftLabel.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.centerY.equalTo(strongSelf)
                make.right.equalTo(strongSelf.rightImageView.snp_left).offset(0)
            }
        }
    }
    
}
