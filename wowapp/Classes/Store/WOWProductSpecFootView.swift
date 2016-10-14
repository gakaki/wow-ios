//
//  WOWProductSpecFootView.swift
//  wowapp
//
//  Created by 安永超 on 16/10/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
protocol ProductSpecFootViewDelegate: class {
    func countClick(_ sender: UIButton!)

}
class WOWProductSpecFootView: UICollectionReusableView {
    @IBOutlet weak var countTextField: UITextField!     //商品数量显示
    @IBOutlet weak var subButton: UIButton!             //增加数量
    @IBOutlet weak var addButton: UIButton!             //减少数量
    
    weak var delegate: ProductSpecFootViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        countTextField.layer.borderColor = MGRgb(234, g: 234, b: 234).cgColor
        addButton.layer.borderColor = MGRgb(234, g: 234, b: 234).cgColor
        subButton.layer.borderColor = MGRgb(234, g: 234, b: 234).cgColor
        // Initialization code
    }
    /**
     显示商品数量
     
     - parameter count: 传入数量
     */
    func showResult(_ count:Int){
        if count <= 1 {
            subButton.isEnabled = false
            subButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
        }else {
            subButton.isEnabled = true
            subButton.setTitleColor(UIColor.black, for: UIControlState())
        }
        self.countTextField.text = "\(count)"
    }
    
    @IBAction func countButtonClick(_ sender: UIButton)  {
        
        if let del = delegate {
            del.countClick(sender)
        }
    }
  
    
}
