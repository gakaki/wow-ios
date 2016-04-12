//
//  WOWUserTopView.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWUserTopView: UIView {
    var topContainerView: UIView!
    var headImageView: UIImageView!
    var nameLabel: UILabel!
    var desLabel: UILabel!
    var bottomContainerView: UIView!
    var focusCountLabel: UILabel!
    var fansCountLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        //上方容器
        topContainerView = UIView()
        topContainerView.backgroundColor = UIColor.whiteColor()
        addSubview(topContainerView)
        weak var weakSelf = self
        topContainerView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.right.top.equalTo(0)
                make.height.equalTo(76)
            }
        }
        
        headImageView = UIImageView()
        //FIXME:测试
        headImageView.image = UIImage(named: "testHeadImage")
        topContainerView.addSubview(headImageView)
        headImageView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.height.width.equalTo(46)
                make.centerY.equalTo(topContainerView)
                make.left.equalTo(topContainerView).offset(15)
            }
        }
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "next_arrow")
        topContainerView.addSubview(arrowImageView)
        arrowImageView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.equalTo(topContainerView.snp_right).offset(-15)
                make.centerY.equalTo(topContainerView)
                make.size.equalTo(CGSizeMake(8, 13))
            }
        }
        
        nameLabel = UILabel()
        //FIXME:
        nameLabel.text = "尖叫君"
        nameLabel.font = Fontlevel001
        nameLabel.textColor = GrayColorlevel1
        topContainerView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.centerY.equalTo(headImageView.snp_centerY).offset(-8)
                make.left.equalTo(headImageView.snp_right).offset(8)
                make.right.equalTo(arrowImageView.snp_left).offset(-8)
            }
        }
        
        desLabel = UILabel()
        desLabel.text = "全力以赴也打不到"
        desLabel.font = FontLevel005
        desLabel.textColor = GrayColorlevel3
        topContainerView.addSubview(desLabel)
        desLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.centerY.equalTo(headImageView.snp_centerY).offset(8)
                make.left.equalTo(headImageView.snp_right).offset(8)
                make.right.equalTo(nameLabel.snp_right)
            }
        }
        
        let centerLine = UIView()
        centerLine.backgroundColor = BorderColor
        topContainerView.addSubview(centerLine)
        centerLine.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        
        //下方容器
        bottomContainerView = UIView()
        bottomContainerView.backgroundColor = UIColor.whiteColor()
        addSubview(bottomContainerView)
        bottomContainerView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.bottom.left.right.equalTo(0)
                make.height.equalTo(44)
            }
        }
        
        let bottomCenterLine = UIView()
        bottomCenterLine.backgroundColor = BorderColor
        bottomContainerView.addSubview(bottomCenterLine)
        bottomCenterLine.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.centerX.equalTo(bottomContainerView.centerX)
                make.top.equalTo(bottomContainerView).offset(8)
                make.bottom.equalTo(bottomContainerView).offset(-8)
                make.width.equalTo(0.5)
            }
        }
        
        focusCountLabel = UILabel()
        //FIXME:
        focusCountLabel.text = "关注"
        focusCountLabel.font = Fontlevel003 //修改
        focusCountLabel.textAlignment = .Center
        bottomContainerView.addSubview(focusCountLabel)
        focusCountLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(bottomCenterLine.snp_left).offset(-1)
            }
        }
        
        fansCountLabel = UILabel()
        //FIXME:
        fansCountLabel.text = "粉丝"
        fansCountLabel.font = Fontlevel003 //修改
        fansCountLabel.textAlignment = .Center
        bottomContainerView.addSubview(fansCountLabel)
        fansCountLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.top.bottom.equalTo(0)
                make.left.equalTo(bottomCenterLine.snp_left).offset(1)
            }
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = BorderColor
        bottomContainerView.addSubview(bottomLine)
        bottomLine.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.right.bottom.equalTo(0)
                make.height.equalTo(0.5)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configShow(loginStatus:LoginStatus) {
        switch loginStatus {
        case .UnLogin:
            self.bottomContainerView.hidden = true
            self.height = 76
        case .Logined:
            self.bottomContainerView.hidden = false
            self.height = 120
        }
    }
    
}
