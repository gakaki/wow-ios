//
//  WOW_SingProductView.swift
//  WOWScrollView
//
//  Created by 陈旭 on 2016/10/19.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit

class WOW_SingProductView: UIView {
    @IBOutlet weak var view_CountDown: UIView?
    // 图片局 左边lable的 数值
    var width : CGFloat  {
        get{
            switch UIDevice.deviceType {
            case .dt_iPhone5:
                return 24.0
            case .dt_iPhone6:
                return 46.0
            case .dt_iPhone6_Plus:
                return 84.0
            default:
                return 24.h
            }
        }
    }
    // 整体局左边距 的 数值
    var leftt : CGFloat  {
        get{
            switch UIDevice.deviceType {
            case .dt_iPhone5:
                return 15.0
            case .dt_iPhone6,.dt_iPhone6_Plus:
                return 30.0
            default:
                return 15.h
            }
        }
    }
    @IBOutlet weak var leftAllLayout: NSLayoutConstraint!
    @IBOutlet weak var imgVieww: UIImageView!
    @IBOutlet weak var leftImageLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()

        leftImageLayout.constant = self.width
        leftAllLayout.constant = self.leftt
        self.layoutIfNeeded()

    }
}