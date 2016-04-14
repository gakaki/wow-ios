//
//  WOWBrandTopView.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

let scale : CGFloat = MGScreenWidth / 375

protocol WOWActionDelegate:class {
    func itemAction(tag:Int)
}

enum WOWItemActionType:Int{
    case Like  = 1001
    case Share = 1002
    case Brand = 1003
}

class WOWBrandTopView: UICollectionReusableView{
    var topHeadView     :   WOWBrandHeadView!
    var underHeadView   :   WOWBrandUnderView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    
    private func configSubviews(){
        topHeadView = WOWBrandHeadView()
        addSubview(topHeadView)
        topHeadView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.top.equalTo(strongSelf).offset(0)
                make.bottom.equalTo(strongSelf).offset(-35)
            }
        }
        
        underHeadView = WOWBrandUnderView()
        underHeadView.backButton.hidden = true
        addSubview(underHeadView)
        underHeadView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.bottom.right.equalTo(strongSelf).offset(0)
                make.top.equalTo(strongSelf.topHeadView.snp_bottom).offset(0)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class WOWBrandHeadView:UIView  {
    var headImageView   :  UIImageView!
    var nameLabel       :  UILabel!
    var backImageView   :  UIImageView!
    weak var delegate   :   WOWActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    private func configSubviews(){
        backImageView = UIImageView()
        //FIXME:测试数据
        backImageView.image = UIImage(named: "testBrandBack")
        backImageView.contentMode = .ScaleAspectFill
        backImageView.clipsToBounds = true
        addSubview(backImageView)
        backImageView.snp_makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.top.bottom.left.right.equalTo(strongSelf).offset(0)
            }
        }
        
        nameLabel = UILabel()
        //FIXME:测试数据
        nameLabel.text = "尖叫君"
        nameLabel.font = FontMediumlevel001
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints {[weak self] (make) in
            if let strongSelf = self{
                make.left.equalTo(strongSelf.snp_left).offset(15)
                make.right.equalTo(strongSelf.snp_right).offset(-15)
                make.bottom.equalTo(strongSelf).offset(-30)
            }
        }
        
        headImageView = UIImageView()
        //FIXME:假数据
        headImageView.image = UIImage(named: "testBrand")
        headImageView.userInteractionEnabled = true
        addSubview(headImageView)
        headImageView.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.centerX.equalTo(strongSelf.snp_centerX)
                make.bottom.equalTo(strongSelf.nameLabel.snp_top).offset(-20)
                make.width.height.equalTo(CGFloat(CGFloat(96) * scale))
            }
        }
        headImageView.borderRadius(CGFloat(96) * scale / 2)
        headImageView.addAction {[weak self] in
            if let strongSelf = self{
                if let del = strongSelf.delegate{
                    del.itemAction(WOWItemActionType.Brand.rawValue)
                }
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSubviews()
    }
}


class WOWBrandUnderView: UIView {
    var likeButton      :  UIButton!
    var shareButton     :  UIButton!
    var locationButton  :  UIButton!
    var backButton      :  UIButton!
    weak var delegate   :  WOWActionDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSubViews()
    }
    
    private func configSubViews(){
        likeButton = UIButton(type: .System)
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        likeButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        likeButton.setImage(UIImage(named: "icon_like")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        likeButton.setImage(UIImage(named: "icon_like_hightlighted")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Selected)
        //FIXME:测数据
        likeButton.setTitle("123", forState: .Normal)
        likeButton.tag = WOWItemActionType.Like.rawValue
        likeButton.addTarget(self, action: #selector(action(_:)), forControlEvents:.TouchUpInside)
        addSubview(likeButton)
        likeButton.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.left.equalTo(strongSelf).offset(15)
                make.bottom.top.equalTo(strongSelf).offset(0)
            }
        }
        
        shareButton = UIButton(type: .System)
        shareButton.setImage(UIImage(named: "icon_share")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        shareButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        shareButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
        shareButton.tag = WOWItemActionType.Share.rawValue
        //FIXME:测数据
        shareButton.setTitle("123", forState: .Normal)
        shareButton.addTarget(self, action: #selector(action(_:)), forControlEvents:.TouchUpInside)
        addSubview(shareButton)
        shareButton.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.left.equalTo(strongSelf.likeButton.snp_right).offset(20)
                make.bottom.top.equalTo(strongSelf).offset(0)
            }
        }
        
        locationButton = UIButton(type: .System)
        locationButton.setImage(UIImage(named: "location")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        locationButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        locationButton.setTitleColor(GrayColorlevel3, forState:.Normal)
        //FIXME:测数据
        locationButton.setTitle("国家", forState: .Normal)
        addSubview(locationButton)
        locationButton.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.right.equalTo(strongSelf).offset(-15)
                make.bottom.top.equalTo(strongSelf).offset(0)
            }
        }
        
        backButton = UIButton(type: .System)
        backButton.setImage(UIImage(named: "up_arrow")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        backButton.addTarget(self, action: #selector(back), forControlEvents:.TouchUpInside)
        addSubview(backButton)
        backButton.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.centerX.equalTo(strongSelf)
                make.bottom.top.equalTo(strongSelf).offset(0)
                make.width.equalTo(50)
            }
        }
    }
    
    func back() {
        let vc = UIApplication.currentViewController()
        if vc is WOWBrandDetailController {
            vc?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            vc?.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func action(btn:UIButton) {
        if let del = delegate {
            del.itemAction(btn.tag)
        }
    }
}




//class LeftRightView: UIView {
//    var rightLabel:UILabel!
//    var leftImageView:UIImageView!
//    convenience init(title:String) {
//        self.init()
//        rightLabel = UILabel()
//        rightLabel.text = title
//        rightLabel.textColor = UIColor.blackColor()
//        rightLabel.font = UIFont.systemFontOfSize(10)
//        addSubview(rightLabel)
//        rightLabel.snp_makeConstraints {[weak self] (make) in
//            if let strongSelf = self{
//                make.right.top.bottom.equalTo(strongSelf).offset(0)
//            }
//        }
//        
//        leftImageView = UIImageView()
//        addSubview(leftImageView)
//        leftImageView.snp_makeConstraints {[weak self] (make) in
//            if let strongSelf = self{
//                make.centerY.equalTo(strongSelf.rightLabel.snp_centerY)
//                make.right.equalTo(strongSelf.rightLabel.snp_left).offset(4)
//                make.left.equalTo(strongSelf).offset(0)
//            }
//        }
//        
//    }
//}
