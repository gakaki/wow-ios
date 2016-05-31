//
//  WOWReuseSectionView.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWReuseSectionView: UICollectionReusableView {

    var titleLabel: UILabel!
    var line      : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        let spaceView = UIView()
        spaceView.backgroundColor = UIColor(hexString:"#EFEFF4")
        addSubview(spaceView)
        spaceView.snp_makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(20)
        }
        
        titleLabel = MGfactoryLabel()
        titleLabel.textAlignment = .Left
        titleLabel.font = Fontlevel003
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(25, 15, 0, 0))
        }
        line = UIView()
        line.backgroundColor = SeprateColor
        self.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self).offset(0)
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
