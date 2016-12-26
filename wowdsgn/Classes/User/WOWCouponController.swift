
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
    
    lazy var emptyView: WOWCouponEmptyView = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWCouponEmptyView.self), owner: self, options: nil)?.last as! WOWCouponEmptyView
        view.frame = CGRect(x: 0, y: 100, w: MGScreenWidth, h: 400)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "优惠券"
        tableView.register(UINib.nibName(String(describing: WOWCouponCell.self)), forCellReuseIdentifier: "WOWCouponCell")
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor
        self.tableView.mj_header = self.mj_header
        self.tableView.mj_footer = self.mj_footer
    }
    

    override func request(){
        super.request()
        var params = [String: AnyObject]()
        switch entrance {
        case .userEntrance:
            params = ["currentPage": pageIndex as AnyObject,"pageSize":pageSize as AnyObject]
        case .orderEntrance:
            params = ["currentPage": pageIndex as AnyObject, "pageSize": pageSize as AnyObject, "minAmountLimit": minAmountLimit as AnyObject? ?? 0 as AnyObject, "couponLimitType": 0 as AnyObject]
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Coupons(params: params), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                
                let arr = Mapper<WOWCouponModel>().mapArray(JSONObject:r["couponList"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.vo_cupons = []
                    }
                    strongSelf.vo_cupons.append(contentsOf: array)
                //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                if array.count < strongSelf.pageSize {
                    strongSelf.tableView.mj_footer = nil
                 
                }else {
                    strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.vo_cupons = []
                    }
                    strongSelf.tableView.mj_footer = nil
                }
                let count = strongSelf.vo_cupons.count
                if count > 0 {
                    strongSelf.emptyView.removeFromSuperview()
                }else {
                    strongSelf.tableView.addSubview(strongSelf.emptyView)
                }
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
            
        }){[weak self] (errorMsg) in
            
            if let strongSelf = self{
                strongSelf.tableView.addSubview(strongSelf.emptyView)

                strongSelf.tableView.mj_footer = nil

                strongSelf.endRefresh()
            }
        }

    }
    //通过优惠码获取优惠券
    func getCoupon(redemotionCode: String) {
    
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_GetCoupon(redemptionCode: redemotionCode), successClosure: {[weak self] (result, code) in
            if let strongSelf = self {
                WOWHud.showMsg("您的优惠码已兑换成功！")
                strongSelf.request()
            }
        }) { (errorMsg) in
            WOWHud.showMsg(errorMsg)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension WOWCouponController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.vo_cupons.count
        if count > 0 {
            return count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWCouponCell", for:indexPath) as! WOWCouponCell
        let count = self.vo_cupons.count
        if count > 0 {
            //这题注意是利用section做分隔 所以一个section 一个row
            let r = self.vo_cupons[(indexPath as NSIndexPath).section]
            cell.label_amount.font = UIFont.priceFont(40)
            cell.label_amount.text          = String(format: "%.f",r.deduction ?? 0)
            cell.label_title.text           = r.title ?? ""
            cell.label_limit.text           = r.limitDesc
            cell.label_time_limit.text      = "\(r.effectiveFrom ?? "")至\(r.effectiveTo ?? "")"
            cell.useCouponBtn.tag = indexPath.section
            cell.useCouponBtn.addTarget(self, action: #selector(goCouponProduct(_:)), for: .touchUpInside)
            
            if ( r.status == 0) { //不可用
                cell.showData(false)
                cell.label_is_used.text         = r.statusDesc
            }else {
                cell.showData(true)
                cell.label_is_used.text         = "未使用"
            }
            
            
            //只有从订单进来的才显示×
            if entrance == .orderEntrance {
                cell.useCouponBtn.isHidden = true
                if r.id == couponModel?.id {
                    r.isSelect = true
                }
                if r.isSelect {
                    cell.image_check.isHidden         = false
                    
                }else {
                    cell.image_check.isHidden         = true
                }
            }

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = vo_cupons[(indexPath as NSIndexPath).section]
        switch entrance {
        case .orderEntrance:
            if coupon.status == 1 {
                if let ac = action{
                    ac(coupon)
                  _ = navigationController?.popViewController(animated: true)
                }
            }
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let count = self.vo_cupons.count
        if count > 0 {
            return 90
        }else {
            return 0.01
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if entrance == .userEntrance {
                return 84
            }else {
                return 90
            }
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if entrance == .userEntrance {
                let view = Bundle.main.loadNibNamed(String(describing: WOWCouponNumberView.self), owner: self, options: nil)?.last as! WOWCouponNumberView
                view.delegate = self
                return view
            }else {
                let view = Bundle.main.loadNibNamed(String(describing: WOWCouponheaderView.self), owner: self, options: nil)?.last as! WOWCouponheaderView
                view.noUseButton.addTarget(self, action: #selector(noUserClick(_:)), for:.touchUpInside)
                return view
            }
        default:
            let view = UIView()
            view.backgroundColor = UIColor.clear
            return view
        }
    }
    
    func noUserClick(_ sender: UIButton)  {
        if let ac = action{
            couponModel = nil
            ac(couponModel ?? "" as AnyObject)
           _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    func goCouponProduct(_ sender: UIButton)  {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWCouponProductController.self)) as! WOWCouponProductController
        let couponModel = self.vo_cupons[sender.tag]
        vc.couponId = couponModel.id ?? 0
        vc.navTitle = couponModel.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WOWCouponController: WOWCouponNumberViewDelegate{
    //MARK: - EmptyData
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyCoupon")
    }
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "没有优惠券哦~"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(74, g: 74, b: 74),NSFontAttributeName:UIFont.systemScaleFontSize(14)])
        return attri
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func convertCouponClick(_ textField: String) {
        getCoupon(redemotionCode: textField)
    }
}
