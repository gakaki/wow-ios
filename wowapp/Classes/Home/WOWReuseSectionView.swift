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
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        titleLabel = MGfactoryLabel()
        titleLabel.textAlignment = .Left
        titleLabel.font = Fontlevel003
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(25, 15, 0, 0))
        }
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
