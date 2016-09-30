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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(_ secondaryImg: WOWProductPicTextModel?) {
        if let secondaryImg = secondaryImg {
            if let img = secondaryImg.image {
                productImg.set_webimage_url(img)
                
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
    func loadImage(_ urlString: String) {
        //定义NSURL对象
        let url = URL(string: urlString)
        var aspect :CGFloat?
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
   
            if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
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
            DispatchQueue.main.async(execute: { () -> Void in
                self.aspectConstraint = NSLayoutConstraint(item: self.productImg,
                    attribute: .width, relatedBy: .equal,
                    toItem: self.productImg, attribute: .height,
                    multiplier: aspect ?? 0, constant: 0.0)
            })
        })
        
    }
}
