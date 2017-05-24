//
//  WOWChooseListCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/17.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWChooseListCell: WOWStyleNoneCell {

    @IBOutlet weak var lbGoodsPrice: UILabel!
    @IBOutlet weak var lbGoodsName: UILabel!
    @IBOutlet weak var lbGoodsNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(model : WOWNewProductModel) {
        
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        lbGoodsPrice.text       = result
        lbGoodsName.text        = model.productName ?? ""
        lbGoodsNumber.text      = ((model.productQty) ?? 1).toString.get_formted_X()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
