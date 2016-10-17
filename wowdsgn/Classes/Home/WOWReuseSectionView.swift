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
        backgroundColor = UIColor.white
        
        titleLabel = MGfactoryLabel()
        titleLabel.textAlignment = .left
        titleLabel.font = Fontlevel004
        titleLabel.textColor = UIColor(hexString: "808080")
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(15, 0, 0, 0))
        }
       
        clearButton = UIButton(type: .custom)
        clearButton.contentHorizontalAlignment = .right
        clearButton.setImage(UIImage(named: "delete"), for: UIControlState())
        self.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.width.equalTo(46)
            make.height.equalTo(30)
            make.rightMargin.equalTo(0)
            make.top.equalTo(10)
        }
        
//        clearButton.addAction {
//            if let del = self.delegate {
//                del.clearHistoryClick()
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
