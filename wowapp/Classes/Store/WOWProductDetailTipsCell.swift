//
//  WOWProductDetailTipsCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailTipsCell: UITableViewCell {

    @IBOutlet weak var telButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
//    @IBOutlet weak var customerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let str = NSMutableAttributedString(string: "商品退换：除定制产品、特价产品外，尖叫设计所售产品均提供7天退换货服务。\n\n商品质量：尖叫设计所售商品均为原创正品，如遇商品签收后发现质量问题，请您签收后24小时内拍照取证并向客服提出反馈，尽快联系客服申请退换货。\n\n配送费用：单个订单高于¥199元包邮，低于¥199元价格为15元，订单中的多件产品，可能会根据发货期的不同进行合理拆单。拆单所产生的额外配送费将由尖叫设计承担。\n\n配送时间：客户下单后我们将在72小时内发货，特殊商品具体到货时间依情况有所差异，我们将在您下单后第一时间与您确认。\n\n发货范围：全国可送（除新疆、西藏、甘肃、青海） 特殊地区（香港、台湾等地）发货与内地发货的邮费计算方式不同，您可于付款前联系客服确认。")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        tipsLabel.attributedText = str
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        telButton.addBorder(width: 1, color:UIColor.blackColor())
//        customerButton.addBorder(width: 1, color:UIColor.blackColor())
    }
    
    @IBAction func callClick(sender: UIButton) {
        WOWTool.callPhone()
    }
    
//    @IBAction func customerServiceClick(sender: UIButton) {
//        DLog("在线客服")
//    }
    
}
