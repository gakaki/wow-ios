//
//  SVCloosePriceCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/1/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class SVCloosePriceCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var minTextF: UITextField!
    @IBOutlet weak var maxTextF: UITextField!
    var modelPrice : PriceSectionModel!{
        didSet{
            if let min = modelPrice.minPrice {
                minTextF.text = min.toString
            }else{
                minTextF.text = ""
            }
            if let max = modelPrice.maxPrice {
                maxTextF.text = max.toString
            }else{
                maxTextF.text = ""
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        minTextF.delegate = self
        maxTextF.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if let priceStr = textField.text {
                
                modelPrice.minPrice = priceStr.toInt()
            }
     
        case 1:
            if let priceStr = textField.text {
                
                modelPrice.maxPrice = priceStr.toInt()
            }

        default:break
        }
    }
}
