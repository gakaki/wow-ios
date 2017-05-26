//
//  WOWRefundListCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWRefundListCell: WOWStyleNoneCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var goodsNumber: UILabel!

    @IBOutlet weak var lbServiceNumber: UILabel!
    @IBOutlet weak var lbAfterType: UILabel!
    @IBOutlet weak var lbAfterProgress: UILabel!
    
    @IBOutlet weak var singsTagView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // 产品UI数据
    func productData(_ model : WOWRefundListModel!){

        titleLabel.text = model.productName
        singsTagView.textFont = UIFont.systemFont(ofSize: 10)
        singsTagView.removeAllTags()
        for sing in model.attributes ?? [""]{
            singsTagView.addTag(sing)
        }
        
        titleImageView.set_webimage_url(model.specImg ?? "")

        if let actualRefundAmount = model.actualRefundAmount {
            if actualRefundAmount == 0 {
                 priceLabel.text = ""
            }else {
                let result = WOWCalPrice.calTotalPrice([actualRefundAmount],counts:[1])
                
                priceLabel.afterListFormat(defaultText: "退款金额：", describeText: result)
            }


        }else {
            priceLabel.text = ""
        }
      
        goodsNumber.text    = ((model.refundItemQty) ?? 1).toString.get_formted_X()
        
        lbServiceNumber.text = model.serviceCode ?? ""
        lbAfterType.text    =   model.refundTypeName ?? ""
        lbAfterProgress.text =  model.refundStatusName ?? ""
        
        
        switch model.refundStatus  ?? 1 {
        case 1:
            lbAfterProgress.textColor = UIColor.black
            break
        case 8,9:
             lbAfterProgress.textColor = UIColor.init(hexString: "#FF7070")!
            break
        default:
            lbAfterProgress.textColor = UIColor.init(hexString: "#5EBF86")!
            break
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
