//
//  WOWProductDetailView.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailView: UIView {
    @IBOutlet weak var productNameLabel:UILabel!
    @IBOutlet weak var productDescLabel:UILabel!
   
    
    func showDataa (model:WOWProductModel) {
        productNameLabel.text = model.productName ?? ""

        
        let descStr = NSMutableAttributedString(string: model.productName ?? "")
        let descStyle = NSMutableParagraphStyle()
        descStyle.lineHeightMultiple = 1.5      //设置1.5倍行距
        descStyle.lineBreakMode = .ByTruncatingTail
        descStyle.alignment = .Center

        descStr.addAttribute(NSParagraphStyleAttributeName, value: descStyle, range: NSMakeRange(0, descStr.length))
        productDescLabel.attributedText = descStr


    }
    
        
}
