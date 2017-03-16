//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol WOWAllClassViewHeaderDelegate {
    func toggleSection(_ header: WOWAllClassViewHeader, section: Int)
}

class WOWAllClassViewHeader: UITableViewHeaderFooterView {
    
    var delegate: WOWAllClassViewHeaderDelegate?
    var section: Int = 0
    
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let imgBanner  = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        

        contentView.addSubview(imgBanner)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WOWAllClassViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgBanner.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.top.equalTo(10)
                make.bottom.equalTo(strongSelf)
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
        }

    }

    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? WOWAllClassViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
      
}
