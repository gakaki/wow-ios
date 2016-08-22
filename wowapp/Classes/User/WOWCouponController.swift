
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
    var vo_cupons = [WOWCouponModel]()
    var minAmountLimit: Double?
    var couponModel:WOWCouponModel?
    var action  : WOWObjectActionClosure?

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
        self.tableView.mj_footer = self.mj_footer
    }
    

    override func request(){
        var params = [String: AnyObject]?()
        switch entrance {
        case .userEntrance:
            params = ["currentPage": pageIndex,"pageSize":pageSize]
        case .orderEntrance:
            params = ["currentPage": pageIndex, "pageSize": pageSize, "minAmountLimit": minAmountLimit ?? 0, "couponLimitType": 0]
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Coupons(params: params), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                
                let arr = Mapper<WOWCouponModel>().mapArray(r["couponList"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.vo_cupons = []
                    }
                    strongSelf.vo_cupons.appendContentsOf(array)
                //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                if array.count < strongSelf.pageSize {
                    strongSelf.tableView.mj_footer = nil
                 
                    }
                }else {
                    strongSelf.tableView.mj_footer = strongSelf.mj_footer
                }

                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
            
        }){[weak self] (errorMsg) in
            
            if let strongSelf = self{

                print(errorMsg)
                strongSelf.tableView.mj_footer = nil

                strongSelf.endRefresh()
            }
        }

    }
    
    func changeColor(cell: WOWCouponCell, color_status: UIColor)  {
        cell.label_amount.textColor             = color_status
        cell.label_title.textColor              = color_status
        cell.label_is_used.textColor            = color_status
        cell.label_time_limit.textColor         = color_status
        
        cell.label_unit.textColor               = color_status
        cell.label_identifier.backgroundColor   = color_status
        
        cell.draw_dashed_line(color_status)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WOWCouponController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.vo_cupons.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWCouponCell", forIndexPath:indexPath) as! WOWCouponCell
        
        //这题注意是利用section做分隔 所以一个section 一个row
        let r = self.vo_cupons[indexPath.section]

            cell.label_amount.text          = r.minAmountLimit?.toString
            cell.label_title.text           = r.couponTitle!
        
            if ( r.status == 0) { //不可用
                cell.label_is_used.text         = r.used ? "已使用":"未使用"
                cell.label_is_used.text         = r.statusDesc
            }
            cell.label_time_limit.text      = "\(r.effectiveFrom!)至\(r.effectiveTo!)"
            
//            var bgView                      = UIView(frame: cell.frame)
//            bgView.backgroundColor          = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.50)
//            cell.addSubview(bgView)
            let color_status_disable        = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.50)
            let color_status_enable         = UIColor(red:0.82, green:0.71, blue:0.58, alpha:1.00)
            
            
            if r.used == true || r.expired == true { //已使用 变灰
               
                changeColor(cell, color_status: color_status_disable)
            }else{
                changeColor(cell, color_status: color_status_enable)
            }
            
            if entrance == .orderEntrance {
                if r.canUsed == false {
                    changeColor(cell, color_status: color_status_disable)
                }else {
                    changeColor(cell, color_status: color_status_enable)
                }
                if r.id == couponModel?.id {
                    r.isSelect = true
                }
                if r.isSelect {
                    cell.image_check.hidden         = false
                    
                }else {
                    cell.image_check.hidden         = true
                }
            }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch entrance {
            
        case .orderEntrance:
                if let ac = action{
                    ac(object: vo_cupons[indexPath.section])
                    navigationController?.popViewControllerAnimated(true)
                }
            
        default:
            return
        }
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
                view.noUseButton.addTarget(self, action: #selector(noUserClick(_:)), forControlEvents:.TouchUpInside)
                return view
            }
        default:
            let view = UIView()
            view.backgroundColor = UIColor.clearColor()
            return view
        }
    }
    
    func noUserClick(sender: UIButton)  {
        if let ac = action{
            couponModel = nil
            ac(object: couponModel ?? "")
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
}
