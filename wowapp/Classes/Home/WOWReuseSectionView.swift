//
//  WOWReuseSectionView.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol WOWReuseSectionViewDelegate: class {
    func clearHistoryClick()
}
class WOWReuseSectionView: UICollectionReusableView {

    var titleLabel: UILabel!
    var clearButton: UIButton!
    weak var delegate: WOWReuseSectionViewDelegate?
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
       
        clearButton = UIButton(type: .Custom)
        clearButton.setTitle("清空", forState: .Normal)
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        clearButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addSubview(clearButton)
        clearButton.snp_makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.rightMargin.equalTo(-15)
            make.top.equalTo(25)
        }
        
        clearButton.addAction {
            if let del = self.delegate {
                del.clearHistoryClick()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
