//
//  CollapsibleTableViewHeader.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let imgBanner  = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //
        // Constraint the size of arrow label for auto layout
        //
//        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
//        arrowLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgBanner)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(arrowLabel)
        
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = UIColor.red
        
//        titleLabel.textColor = UIColor.white
//        arrowLabel.textColor = UIColor.white
        
        //
        // Autolayout the lables
        //
        
        imgBanner.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.bottom.top.left.right.equalTo(strongSelf)

            }
        }

    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
//        arrowLabel.rotate(collapsed ? 0.0 : CGFloat(M_PI_2))
    }
    
}
