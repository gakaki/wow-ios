//
//  WOWBanner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/25.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWBanner: UIView {
    var imageURLArray: [String] = []
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func reloadBanner(dataArr:[WOWCarouselBanners]){
        for i in 0..<dataArr.count {
            imageURLArray.append(dataArr[i].bannerImgSrc! as String)
        }

        cyclePictureView.showPageControl = false
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.timeInterval = 5

    }

}
