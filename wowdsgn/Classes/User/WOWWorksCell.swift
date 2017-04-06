//
//  WOWWorksCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksCell: UICollectionViewCell {
    class var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 12) / 3
        }
    }
    @IBOutlet weak var imageView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(_ model:WOWWorksListModel) {
        let url             = model.pic ?? ""
        imageView.set_webimage_url( url)

    }
    

}