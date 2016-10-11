//
//  WOWUserTopView.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWUserTopView: UIView {
    var loginLabel:UILabel!
    var topContainerView: UIView!
    var headImageView: UIImageView!
    var nameLabel: UILabel!
    var desLabel: UILabel!
    fileprivate var bottomContainerView: UIView!
    var focusCountLabel: UILabel!
    var fansCountLabel: UILabel!
    var focusBackView:UIView!
    var fansBackView:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        //上方容器
        topContainerView = UIView()
        topContainerView.backgroundColor = UIColor.white
        addSubview(topContainerView)
        weak var weakSelf = self
        topContainerView.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.right.top.equalTo(0)
                make.height.equalTo(76)
            }
        }
        
        headImageView = UIImageView()
        headImageView.image = UIImage(named: "placeholder_userhead")
        topContainerView.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.height.width.equalTo(46)
                make.centerY.equalTo(topContainerView)
                make.left.equalTo(topContainerView).offset(15)
            }
        }
        headImageView.borderRadius(23)
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "next_arrow")
        topContainerView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.equalTo(topContainerView.snp.right).offset(-15)
                make.centerY.equalTo(topContainerView)
                make.size.equalTo(CGSize(width:9, height:16))
            }
        }
        
        nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.font = Fontlevel000
        nameLabel.textColor = GrayColorlevel1
        topContainerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.centerY.equalTo(headImageView.snp.centerY).offset(-8)
                make.left.equalTo(headImageView.snp.right).offset(15)
                make.right.equalTo(arrowImageView.snp.left).offset(-8)
            }
        }
        
        desLabel = UILabel()
        desLabel.text = "全力以赴也打不到"
        desLabel.font = FontLevel005
        desLabel.textColor = GrayColorlevel3
        topContainerView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.centerY.equalTo(headImageView.snp.centerY).offset(12)
                make.left.equalTo(headImageView.snp.right).offset(15)
                make.right.equalTo(nameLabel.snp.right)
            }
        }
        
        let centerLine = UIView()
        centerLine.backgroundColor = SeprateColor
        topContainerView.addSubview(centerLine)
        centerLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        loginLabel = UILabel()
        loginLabel.text = "点击登录/注册"
        loginLabel.font = Fontlevel001
        loginLabel.textColor = GrayColorlevel3
        loginLabel.isHidden = true
        topContainerView.addSubview(loginLabel)
        loginLabel.snp.makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.equalTo(headImageView.snp.right).offset(8)
                make.centerY.equalTo(topContainerView.centerY).offset(0)
                make.right.lessThanOrEqualTo(topContainerView.right).offset(-15)
            }
        }
        
        
        
        //下方容器
        /*
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
        
        focusBackView = UIView()
        focusBackView.backgroundColor = UIColor.whiteColor()
        bottomContainerView.addSubview(focusBackView)
        focusBackView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(bottomCenterLine.snp_left).offset(-1)
            }
        }
        
        let smallView1 = UIView()
        focusBackView.addSubview(smallView1)
        smallView1.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.top.bottom.equalTo(0)
                make.centerX.equalTo(focusBackView.centerX).offset(0)
            }
        }
        let l1 = createLabel("关注")
        smallView1.addSubview(l1)
        l1.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.top.bottom.equalTo(0)
            }
        }
        
        focusCountLabel = createNumberLabel()
        //FIXME:
        focusCountLabel.text = "123"
        smallView1.addSubview(focusCountLabel)
        focusCountLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(l1.snp_left).offset(-2)
            }
        }
        
        
        
        fansBackView = UIView()
        fansBackView.backgroundColor = UIColor.whiteColor()
        bottomContainerView.addSubview(fansBackView)
        fansBackView.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.top.bottom.equalTo(0)
                make.left.equalTo(bottomCenterLine.snp_right).offset(1)
            }
        }
       
        let smallView2 = UIView()
        fansBackView.addSubview(smallView2)
        smallView2.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.top.bottom.equalTo(0)
                make.centerX.equalTo(fansBackView.centerX).offset(0)
            }
        }
        let l2 = createLabel("粉丝")
        smallView2.addSubview(l2)
        l2.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.right.top.bottom.equalTo(0)
            }
        }
        //FIXME:
        fansCountLabel = createNumberLabel()
        fansCountLabel.text = "321"
        smallView2.addSubview(fansCountLabel)
        fansCountLabel.snp_makeConstraints { (make) in
            if let _ = weakSelf{
                make.left.top.bottom.equalTo(0)
                make.right.equalTo(l2.snp_left).offset(-2)
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
        */
    }
    
    fileprivate func createNumberLabel() ->UILabel{
        let l1 = UILabel()
        l1.textColor = GrayColorlevel1
        l1.font = Fontlevel001
        return l1
    }
    
    fileprivate func createLabel(_ title:String) ->UILabel{
        let l1 = UILabel()
        l1.text = title
        l1.textColor = GrayColorlevel3
        l1.font = Fontlevel004
        return l1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configShow(_ loginStatus:Bool) {
        switch loginStatus {
        case false:
            loginLabel.isHidden = false
            nameLabel.isHidden = true
            desLabel.isHidden = true
//            self.bottomContainerView.hidden = true
//            self.height = 76
        case true:
            break
//            self.bottomContainerView.hidden = false
//            self.height = 120
        }
    }
    
}
