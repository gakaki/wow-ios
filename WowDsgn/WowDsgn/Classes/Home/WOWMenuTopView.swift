//
//  WOWMenuTopView.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWMenuTopView: UIView {
    var rightButton:UIButton!
    var leftLabel:UILabel!
    var topLine:UILabel!
    var bottomLine:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        configSubviews()
    }

    private func configSubviews(){
        leftLabel = MGfactoryLabel()
        leftLabel.text = "商品分类"
        leftLabel.font = Fontlevel003
        leftLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(leftLabel)
        weak var weakSelf = self
        leftLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(weakSelf!).offset(15)
            make.centerY.equalTo(weakSelf!.snp_centerY)
        }
        
        rightButton = UIButton(type: .System)
        self.addSubview(rightButton)
        weak var weakLabel = leftLabel
        rightButton.setImage(UIImage(named: "close")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        rightButton.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(40)
            make.centerY.equalTo((weakLabel?.snp_centerY)!)
            make.right.equalTo(weakSelf!).offset(0)
        }
        
        topLine = UILabel()
        topLine.backgroundColor = SeprateColor
        self.addSubview(topLine)
        topLine.snp_makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(weakSelf!).offset(0)
            make.top.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
        }
        
        bottomLine = UILabel()
        bottomLine.backgroundColor = SeprateColor
        self.addSubview(bottomLine)
        bottomLine.snp_makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(weakSelf!).offset(0)
            make.right.equalTo(weakSelf!).offset(0)
            make.bottom.equalTo(weakSelf!).offset(0)
        }
        bottomLine.hidden = true
        topLine.hidden = true
        
    }
    
    func showLine(show:Bool) {
        bottomLine.hidden = !show
        topLine.hidden = !show
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(leftTitle:String!,rightHiden:Bool,topLineHiden:Bool,bottomLineHiden:Bool) {
        self.init(frame:CGRectMake(0,0,MGScreenWidth,36))
        rightButton.setImage(UIImage(named: "next_arrow")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
        leftLabel.text = leftTitle
        rightButton.userInteractionEnabled = false
        rightButton.hidden = rightHiden
        topLine.hidden = topLineHiden
        bottomLine.hidden = bottomLineHiden
    }
    
    
}
