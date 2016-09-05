//
//  HomeBrannerCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/5.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class HomeBrannerCell: UITableViewCell {
    var imageURLArray: [String] = []
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func reloadBanner(dataArr:[WOWCarouselBanners]){
        imageURLArray = []
        for i in 0..<dataArr.count {
            imageURLArray.append(dataArr[i].bannerImgSrc! as String)
        }
        
        cyclePictureView.showPageControl = true
        cyclePictureView.currentDotColor = UIColor.blackColor()
        cyclePictureView.otherDotColor = UIColor.whiteColor()
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.timeInterval = 3
     
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
