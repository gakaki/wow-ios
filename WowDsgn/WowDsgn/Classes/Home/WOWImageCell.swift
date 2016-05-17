//
//  WOWImageCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWImageCell: UICollectionViewCell {
    
    class var itemWidth:CGFloat{
        get{
            return (MGScreenWidth - 1) / 2
        }
    }
    
    var pictureImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = SeprateColor
        pictureImageView = UIImageView()
        self.addSubview(pictureImageView)
        pictureImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, -0.5, -0.5))
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
