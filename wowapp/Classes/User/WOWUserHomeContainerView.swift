//
//  WOWUserHomeContainerView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWUserHomeContainerView: UICollectionReusableView {
    var topHeadView     :  WOWUserHomeTopView!
    var underCheckView  : WOWTopMenuTitleView!
    override init(frame:CGRect){
        super.init(frame: frame)
        configSubviews()
    }
    
    fileprivate func configSubviews(){
        backgroundColor = UIColor.white
        topHeadView = Bundle.main.loadNibNamed("WOWUserHomeTopView", owner:self, options: nil)?.last as! WOWUserHomeTopView
        addSubview(topHeadView)
        topHeadView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.top.equalTo(strongSelf).offset(0)
                make.bottom.equalTo(strongSelf).offset(-40)
            }
        }
    
        topHeadView.focusButton.addTarget(self, action:#selector(focusButtonClick), for:.touchUpInside)
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = false
        WOWCheckMenuSetting.selectedIndex = 1
        underCheckView = WOWTopMenuTitleView(frame:CGRect(x: 0, y: 0, width: MGScreenWidth, height: 36), titles: ["喜欢的场景","喜欢的单品"])
        addSubview(underCheckView)
        underCheckView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.equalTo(strongSelf).offset(0)
//                make.bottom.equalTo(strongSelf).offset(-2)
                make.height.equalTo(36)
                make.top.equalTo(strongSelf.topHeadView.snp_bottom).offset(0)
            }
        }
        
        let line = UIView()
        line.backgroundColor = BorderColor
        addSubview(line)
        line.snp_makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.right.equalTo(strongSelf).offset(0)
                make.top.equalTo(strongSelf.underCheckView.snp_bottom).offset(0)
                make.height.equalTo(0.5)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showData() {
        //FIXME:假数据
        topHeadView.nameLabel.text = "尖叫君"
        topHeadView.desLabel.text = "念念不忘，必有回响"
        topHeadView.focusLabel.text = "234  关注"
        topHeadView.fansLabel.text = "291  粉丝"
        topHeadView.headImageView.image = UIImage(named: "testBrand")
    }
    
    func focusButtonClick() {
        DLog("加关注或者取消关注咯")
    }

}
