//
//  WOWNoNetView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/22.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

typealias RefreshBlock =  () -> ()
class WOWNoNetView: UIView {
    var refreshDataBlock :RefreshBlock!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "f5f5f5")
        cofigView()
    }
    
    func cofigView()  {
        self.addSubview(self.imgBack)
        self.addSubview(self.lbTitle)
        self.addSubview(self.btnRefresh)
        self.imgBack.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.centerX)
                make.width.equalTo(49)
                make.height.equalTo(63)
                make.top.equalTo(strongSelf).offset(150)
            }
        }
        self.lbTitle.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.centerX)
                make.width.equalTo(320)
                make.height.equalTo(21)
                make.top.equalTo(strongSelf.imgBack).offset(83)
            }
        }
        
        self.btnRefresh.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.centerX.equalTo(strongSelf.centerX)
                make.width.equalTo(80)
                make.height.equalTo(35)
                make.top.equalTo(strongSelf.lbTitle).offset(45)
            }
        }
        
    }
    func showView(view:UIView) {
        view.addSubview(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imgBack:UIImageView = {
        
        let imgBack = UIImageView()
        imgBack.image = UIImage.init(named: "no_NetWork")
        
        return imgBack
        
    }()
    lazy var lbTitle:UILabel = {
        
        let lbTitle = UILabel()
        lbTitle.text = "网络不给力，请检查网络"
        lbTitle.textColor = UIColor.init(hexString: "808080")
        
        lbTitle.font = UIFont.systemFont(ofSize: 14)
        lbTitle.textAlignment = .center
        return lbTitle
        
    }()
    lazy var btnRefresh:UIButton = {
        
        let btnRefresh = UIButton.init(type: UIButtonType.custom)
        btnRefresh.setTitle("刷新", for: .normal)
        btnRefresh.setTitleColor(UIColor.init(hexString: "808080"), for: UIControlState.normal)
        btnRefresh.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btnRefresh.backgroundColor = UIColor.init(hexString: "eaeaea")
        btnRefresh.addTarget(self, action: #selector(WOWNoNetView.clickAction), for: .touchUpInside)
        return btnRefresh
        
    }()
    func clickAction(){
        refreshDataBlock()
    }
    func removeNoDataAndNetworkView(){
//        if self {
       
            self.removeFromSuperview()
//        }
    }
}

