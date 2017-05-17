//
//  WOWRefundMoneyGoodsCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/15.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
typealias MaxMoneyStr = (_ str:String) -> ()
class WOWRefundMoneyGoodsCell: WOWStyleNoneCell,UITextFieldDelegate {
    var maxMontyStr:MaxMoneyStr?
    @IBOutlet weak var lbFreight: UILabel!
    @IBOutlet weak var lbMaxRefundMoney: UILabel!
    @IBOutlet weak var tfMoeny: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        tfMoeny.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    func textFieldDidChange(_ textField: UITextField) {
        if let maxMontyStr = maxMontyStr {
            
            maxMontyStr(textField.text ?? "")
            
        }

    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
