//
//  CyclePictureCell.swift
//  CyclePictureView
//
//  Created by wl on 15/11/7.
//  Copyright © 2015年 wl. All rights reserved.
//

/***************************************************
 *  如果您发现任何BUG,或者有更好的建议或者意见，欢迎您的指出。
 *邮箱:wxl19950606@163.com.感谢您的支持
 ***************************************************/

import UIKit

class CyclePictureCell: UICollectionViewCell {

    var imageSource: ImageSource = ImageSource.local(name: ""){
        didSet {
            switch imageSource {
            case let .local(name):
                self.imageView.image = UIImage(named: name)
            case let .network(urlStr):
                
                
                self.imageView.kf.setImage(with: URL(string:urlStr), placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
               
            
            }
        }
    }
    
    var placeholderImage: UIImage?
    
    var imageDetail: String? {
        didSet {
            detailLable.isHidden = false
            detailLable.text = imageDetail

        }
    }
    
    var detailLableTextFont: UIFont = UIFont(name: "Helvetica-Bold", size: 18)! {
        didSet {
            detailLable.font = detailLableTextFont
        }
    }
    
    var detailLableTextColor: UIColor = UIColor.white {
        didSet {
            detailLable.textColor = detailLableTextColor
        }
    }
    
    var detailLableBackgroundColor: UIColor = UIColor.clear {
        didSet {
            detailLable.backgroundColor = detailLableBackgroundColor
        }
    }
    
    var detailLableHeight: CGFloat = 60 {
        didSet {
            detailLable.frame.size.height = detailLableHeight
        }
    }
    
    var detailLableAlpha: CGFloat = 1 {
        didSet {
            detailLable.alpha = detailLableAlpha
        }
    }
    
    var pictureContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = pictureContentMode
        }
    }
    
     var imageView: UIImageView!
    fileprivate var detailLable: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupImageView()
        self.setupDetailLable()
//        self.backgroundColor = UIColor.grayColor()
    }
    
    fileprivate func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = pictureContentMode
        imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    fileprivate func setupDetailLable() {
        detailLable = UILabel()
        detailLable.textColor = detailLableTextColor
        detailLable.shadowColor = UIColor.gray
        detailLable.numberOfLines = 0
        detailLable.backgroundColor = detailLableBackgroundColor

        detailLable.isHidden = true //默认是没有描述的，所以隐藏它
        
        self.addSubview(detailLable!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds

        if let _ = self.imageDetail {
            let lableX: CGFloat = 0
            let lableH: CGFloat = detailLableHeight
            let lableW: CGFloat = self.frame.width - lableX
            let lableY: CGFloat = self.frame.height - lableH
            detailLable.frame = CGRect(x: lableX, y: lableY, width: lableW, height: lableH)
            detailLable.font = detailLableTextFont
        }
    }
}
