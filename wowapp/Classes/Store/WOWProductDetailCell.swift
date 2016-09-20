//
//  WOWProductDetailCell.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailCell: UITableViewCell {
    @IBOutlet weak var productImg:UIImageView!
    @IBOutlet weak var imgDescLabel:UILabel!
    @IBOutlet weak var multiplier: NSLayoutConstraint!
    @IBOutlet weak var space: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                productImg.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                productImg.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(secondaryImg: WOWProductPicTextModel?) {
        if let secondaryImg = secondaryImg {
            if let img = secondaryImg.image {
                productImg.kf_setImageWithURL(NSURL(string:img)!, placeholderImage:UIImage(named: "placeholder_product"))
//                bottomSpace.constant = 30
////                productImg.kf_indicator?.setScale(x: 100, y: 1000)
            }else {
                space.constant = 0
                multiplier.constant = 345
            }
        
//            dispatch_async(dispatch_get_main_queue()) {
//                
//                 self.loadImage(secondaryImg.image!)
//            }
//           
//            productImg.set_webimage_url_base(secondaryImg.image, place_holder_name: "placeholder_product")
            imgDescLabel.text = secondaryImg.text
            imgDescLabel.setLineHeightAndLineBreak(1.5)

        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
//        aspectConstraint = nil
    }

    //加载内容图片（并设置高度约束）
    func loadImage(urlString: String) {
        //定义NSURL对象
        let url = NSURL(string: urlString)
        var aspect :CGFloat?
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
   
            if let data = NSData(contentsOfURL: url!), image = UIImage(data: data) {
                //计算原始图片的宽高比
                aspect = image.size.width / image.size.height
                //            //设置imageView宽高比约束
                               //            //加载图片
                //
            }else{
                //去除imageView里的图片和宽高比约束
                self.aspectConstraint = nil
                self.productImg.image = nil
            }

            
            //操作完成，调用主线程来刷新界面
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                println("main refresh")
                self.aspectConstraint = NSLayoutConstraint(item: self.productImg,
                    attribute: .Width, relatedBy: .Equal,
                    toItem: self.productImg, attribute: .Height,
                    multiplier: aspect ?? 0, constant: 0.0)

            })
        })
     
           }
}
