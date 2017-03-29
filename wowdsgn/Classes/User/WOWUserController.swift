//
//  WOWUserController.swift
//  Wow
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import StoreKit

class WOWUserController: WOWBaseTableViewController {
    
    @IBOutlet weak var allOrderView : UIView!
    @IBOutlet weak var noPayView    : UIView!
    @IBOutlet weak var noSendView   : UIView!
    @IBOutlet weak var noReceiveView: UIView!
    @IBOutlet weak var noCommentView: UIView!
    var userModel: WOWStatisticsModel?
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar = true
        super.viewWillAppear(animated)
        isCurrentRequest = true
        request()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var headerView:WOWUserHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWUserHeaderView.self), owner: self, options: nil)?.last as! WOWUserHeaderView
        v.userBack.addAction({
            VCRedirect.goUserCenter()
        })
        v.editBtn.addTarget(self, action: #selector(goUserInfo), for:.touchUpInside)
        return v
    }()
    

//MARK:Private Method
    override func setUI() {
        super.setUI()
        configHeaderView()
        configClickAction()
        addObserver()
    }

     
    
    fileprivate func configClickAction(){
        
        MobClick.e(.My_Orders)

        
        allOrderView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.goOrder(0)
            }
        }
        noPayView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.goOrder(1)
            }
        }
        noSendView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.goOrder(2)
            }
        }
        noReceiveView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.goOrder(3)
            }
        }
        noCommentView.addTapGesture {[weak self](tap) in
            if let strongSelf = self{
                strongSelf.goOrder(4)
            }
        }
    }
    
    func goOrder(_ type:Int) {
        

        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }

        let vc = WOWOrderListViewController()
        vc.selectCurrentIndex = type
        navigationController?.pushViewController(vc, animated: true)
    }
   
    fileprivate func configHeaderView(){

        self.tableView.addSubview(headerView)
        let userView = UIView(frame: CGRect(x: 0, y: 0, width: MGScreenWidth, height: 9/16*MGScreenWidth))
        userView.isUserInteractionEnabled = false
        self.tableView.tableHeaderView = userView
    }

    
    /**
     刷新headerView上面的用户信息
     */
    func refreshUserInfo() {
        headerView.configUserInfo(model: userModel)
    }
    
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
    }
    
//MARK:Actions

    func goUserInfo() {
        VCRedirect.goUserInfo()
    }
    
    func exitLogin() {
        userModel = nil
        refreshUserInfo()
    }


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headerView.frame = CGRect(x: 0, y: offsetY, width: MGScreenWidth, height: 9/16*MGScreenWidth - offsetY)
        }
    }
    
    //MAERK: Net
    override func request() {
        super.request()
        let param = [String: AnyObject]()
        WOWNetManager.sharedManager.requestWithTarget(.api_UserStatistics(params: param), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let model = Mapper<WOWStatisticsModel>().map(JSONObject:result)
                if model != strongSelf.userModel {
                    strongSelf.userModel = model
                    strongSelf.refreshUserInfo()
                }
            }
            
        }) { (errorMsg) in
            
        }

    }
}


//MARK:Delegate
extension WOWUserController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (1, 0):  //喜欢的商品
            VCRedirect.goFavorite()
            return
        case (1, 1): //我的礼券
            VCRedirect.toCouponVC()
        case (2,0): //打电话
            WOWTool.callPhone()
            MobClick.e(.Service_Phone)
            return
        case (2,1): //关于尖叫设计
            VCRedirect.goAbout()
            return
        case (2,2)://设置
            VCRedirect.goSetting()
            return
        default:
            break
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 50
        }else {
            return 0.01

        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = GrayColorLevel5
        return headView
        
    }
    
    
 
    
}
