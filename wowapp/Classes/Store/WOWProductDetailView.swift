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
        productDescLabel.text = model.sellingPoint ?? ""
        productDescLabel.setLineHeightAndLineBreak(1.5)
    }
    
        
}
