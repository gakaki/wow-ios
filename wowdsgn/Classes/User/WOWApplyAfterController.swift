//
//  WOWApplyAfterController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum GoodsSendType {
    case noSendGoods    // 待发货
    case sendGoods      // 以发货
}
struct RefundReason {
    var title       : String
    var describe    : String
    var icon        : String
}
class WOWApplyAfterController: WOWBaseViewController {
    
    let tableView: UITableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    // 释放资源属性
    let disposeBag = DisposeBag()
    // 资源类熟悉
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,RefundReason>>()
    // 数据源
    var reasonArray = [RefundReason]()
    
    let reason  = RefundReason(title:"退货退款", describe:"已收到货，需要退还已收到的货物", icon:"refund_barter")
    let reason1 = RefundReason(title:"仅退款", describe:"未收到货，协商退款", icon:"refund")
    let reason2 = RefundReason(title:"换货", describe:"对已收到的货物不满意，协商换货", icon:"barter")
    let reason3 = RefundReason(title:"整单退款", describe:"还未发货，协商整单取消", icon:"refund_barter")

    var sendType                : GoodsSendType = .noSendGoods{
        didSet{
            switch sendType {
            case .sendGoods:
                reasonArray = [reason,reason1,reason2]
                break
            default:
                reasonArray = [reason3,reason1]
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
        tableView.cellId_register("WOWApplyAfterCell")
        tableView.separatorStyle    = .none
        tableView.backgroundColor   = GrayColorLevel5
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 60
        view.addSubview(tableView)
        // 配置cell
        dataSource.configureCell = {
            (_, tableView, indexPath, reason) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWApplyAfterCell", for: indexPath) as! WOWApplyAfterCell
            
            cell.lbTitle.text       = reason.title
            cell.lbDescribe.text    = reason.describe
            cell.imgAicon.image     = UIImage.init(named: reason.icon)
            
            return cell
        }
        let sections = [
            SectionModel(model: "", items: reasonArray)
        ]
        let items = Observable.just(sections)
        items.bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(disposeBag)
        tableView.rx.itemSelected.subscribe {[unowned self] (indexpath) in
                if let index = indexpath.element {
                    self.goOnlyRefundVC(indexPath: index)
                }
            }.addDisposableTo(disposeBag)

    }

    func goOnlyRefundVC(indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            switch sendType {
            case .noSendGoods:
                VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId,afterType: .SendNo_AllOrderRefund)
            default:
                VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId,afterType: .RefundMoney)
            }
            
        case 1:
            
            switch sendType {
            case .noSendGoods:
                VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId,afterType: .SendNo_OnlyRefund)
            default:
                VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId,afterType: .OnlyRefund)
            }
        case 2:
            
            VCRedirect.goOnlyRefund(orderCode:orderCode,saleOrderItemId:saleOrderItemId,afterType: .ExchangGoods)
            
        default:
            break
        }
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
