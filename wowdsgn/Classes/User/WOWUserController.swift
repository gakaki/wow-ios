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
//    var headerView      :   WOWUserTopView!
    var image_next_view: UIImage!
    
    @IBOutlet weak var allOrderView : UIView!
    @IBOutlet weak var noPayView    : UIView!
    @IBOutlet weak var noSendView   : UIView!
    @IBOutlet weak var noReceiveView: UIView!
    @IBOutlet weak var noCommentView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar = true
        super.viewWillAppear(animated)
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

//        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
//        vc.selectIndex = type
        let vc = WOWOrderListViewController()
        vc.selectCurrentIndex = type
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     刷新headerView上面的用户信息
     */
    fileprivate func configHeaderView(){
//        headerView       = WOWUserTopView()
//        headerView.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 270)
//        headerView.configShow(WOWUserManager.loginStatus)
//        headerView.topContainerView.addAction {[weak self] in
//            if let strongSelf = self{
//                if WOWUserManager.loginStatus{
//                    strongSelf.goUserInfo()
//                }else{
//                    strongSelf.toLoginVC(true)
//                }
//            }
//        }
//        configUserInfo()
//        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(headerView)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: MGScreenWidth, height: 9/16*MGScreenWidth))
    }
    
    fileprivate func goUserInfo(){
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserInfoController.self)) as! WOWUserInfoController
        vc.editInfoAction = { [weak self] in
            if let strongSelf = self{
                strongSelf.configUserInfo()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func configUserInfo(){
//        if WOWUserManager.loginStatus {
//            
//            if ( self.image_next_view != nil){
//                headerView.headImageView.image =  self.image_next_view 
//            }else{
//                /**
//                 *  先判断 本地是否有保存头像数据
//                 */
//                if   WOWUserManager.userPhotoData.isEmpty {
//                    headerView.headImageView.set_webimage_url_base(WOWUserManager.userHeadImageUrl, place_holder_name: "placeholder_userhead")
////                    headerView.headImageView.set_webimage_url_user( WOWUserManager.userHeadImageUrl )
//                    
//
//                }else{
//                    DispatchQueue.main.async {
//                        // 取头像数据
//                        if let myImage = NSKeyedUnarchiver.unarchiveObject(with: WOWUserManager.userPhotoData as Data) as? UIImage {
//                            self.headerView.headImageView.image = myImage
//
//                        }
//                        
//                    }
//                }
//
//              }
//            // UI
//            headerView.nameLabel.text = WOWUserManager.userName
//            headerView.desLabel.text  = WOWUserManager.userDes
//        }else{
//            headerView.headImageView.image = UIImage(named: "placeholder_userhead")
//        }
    }
    
    
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
        NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(changeHeaderImage), name:NSNotification.Name(rawValue: WOWUpdateUserHeaderImageNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
         NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWChangeUserInfoNotificationKey), object:nil)
    }
    
//MARK:Actions

    func changeHeaderImage(_ notification: Notification){
        
        let userInfo = (notification as NSNotification).userInfo
        if  let image  = userInfo!["image"] as? UIImage {
//            self.headerView.headImageView.image = image
            self.image_next_view = image
        }

    }
    
    
    func exitLogin() {
        self.image_next_view = nil
        configHeaderView()
    }
    
    func loginSuccess(){
        configHeaderView()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headerView.frame = CGRect(x: 0, y: offsetY, width: MGScreenWidth, height: 9/16*MGScreenWidth - offsetY)
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
    
    fileprivate func evaluateApp(){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAboutController") as! WOWAboutController
        navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
}
