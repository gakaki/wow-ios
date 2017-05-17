//
//  WOWApplyAfterController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum AfterType {
    case noSendGoods    // 待发货
    case sendGoods      // 以发货
}
class WOWApplyAfterController: WOWApplyAfterBaseController {
   
    var sendType                : AfterType = .noSendGoods{
        didSet{
            switch sendType {
            case .sendGoods:
                cellLineNumber  = 3
                titlyArray      = ["退货退款",
                                   "仅退款",
                                   "换货"]
                describeArray   = ["已收到货，需要退还已收到的货物",
                                   "未收到货，协商退款",
                                   "对已收到的货物不满意，协商换货"]
                break
            default:
                cellLineNumber  = 2
                titlyArray      = ["整单退款",
                                   "仅退款"]
                describeArray   = ["还未发货，协商整单取消",
                                   "未收到货，协商退款"]
                break
            }

        }
    }
    var titlyArray      : [String] = []
    var describeArray   : [String] = []
    var imgAcionArray   : [String] = ["refund_barter","refund","barter"]
    var  cellLineNumber : Int      = 0
    
    var orderCode                   : String!
    var saleOrderItemId             : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "申请售后"

    }
    override func setUI() {
        super.setUI()

        tableView.register(UINib.nibName("WOWApplyAfterCell"), forCellReuseIdentifier: "WOWApplyAfterCell")

    }
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLineNumber
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWApplyAfterCell", for: indexPath) as! WOWApplyAfterCell
            cell.lbTitle.text       = titlyArray[index]
            cell.lbDescribe.text    = describeArray[index]
            cell.imgAicon.image     = UIImage.init(named: imgAcionArray[index])
            cell.selectionStyle     = .none
            return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
