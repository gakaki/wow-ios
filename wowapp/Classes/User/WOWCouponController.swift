//
//  WOWCouponController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/15.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

enum couponEntrance {
    case userEntrance
    case orderEntrance
}

class WOWCouponController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let pageSize        = 20
    var vo_cupons:[WOWCouponModel]?

    var entrance        = couponEntrance.userEntrance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "优惠券"
        tableView.registerNib(UINib.nibName(String(WOWCouponCell)), forCellReuseIdentifier: "WOWCouponCell")
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor
        self.tableView.mj_header = self.mj_header

    }
    
    override func request(){
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Coupons(currentPage: pageIndex, pageSize: pageSize), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                strongSelf.vo_cupons                      =  Mapper<WOWCouponModel>().mapArray(r["couponList"].arrayObject) ?? [WOWCouponModel]()
                
                self!.tableView.reloadData()
                self?.endRefresh()
            }
            
        }){ (errorMsg) in
            print(errorMsg)
            self.endRefresh()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WOWCouponController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.vo_cupons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWCouponCell", forIndexPath:indexPath) as! WOWCouponCell
        
        //这题注意是利用section做分隔 所以一个section 一个row
        if let r = self.vo_cupons?[indexPath.section] {

            cell.label_amount.text          = r.minAmountLimit?.toString
            cell.label_title.text           = r.couponTitle!
            
            cell.label_is_used.text         = r.used ? "已使用":"未使用"
            cell.label_time_limit.text      = "\(r.effectiveFrom!)至\(r.effectiveTo!)"
            
//            var bgView                      = UIView(frame: cell.frame)
//            bgView.backgroundColor          = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.50)
//            cell.addSubview(bgView)
            let color_status_disable        = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.50)
            let color_status_enable         = UIColor(red:0.82, green:0.71, blue:0.58, alpha:1.00)
            var color_status                = color_status_enable
            
            
            if r.used == true && r.expired == true { //已使用 变灰
                
                color_status                            = color_status_disable
                
                cell.label_amount.textColor             = color_status
                cell.label_title.textColor              = color_status
                cell.label_is_used.textColor            = color_status
                cell.label_time_limit.textColor         = color_status
                
                cell.label_unit.textColor               = color_status
                cell.label_identifier.backgroundColor   = color_status

                cell.draw_dashed_line(color_status_disable)

            }else{
                color_status                    = color_status_enable
                cell.label_is_used.textColor    = color_status
                cell.draw_dashed_line()

            }
            if entrance == .userEntrance {
                cell.image_check.hidden         = true
            }
           
           
        }
       
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if entrance == .userEntrance {
                return 15
            }else {
                return 90
            }
        default:
            return 15
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if entrance == .userEntrance {
                let view = UIView()
                view.backgroundColor = UIColor.clearColor()
                return view
            }else {
                let view = NSBundle.mainBundle().loadNibNamed(String(WOWCouponheaderView), owner: self, options: nil).last as! WOWCouponheaderView
                return view
            }
        default:
            let view = UIView()
            view.backgroundColor = UIColor.clearColor()
            return view
        }
    }
}
