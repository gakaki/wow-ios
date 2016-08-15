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
    var headerView      :   WOWUserTopView!
    
    @IBOutlet weak var allOrderView : UIView!
    @IBOutlet weak var noPayView    : UIView!
    @IBOutlet weak var noSendView   : UIView!
    @IBOutlet weak var noReceiveView: UIView!
    @IBOutlet weak var noCommentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

//MARK:Private Method
    override func setUI() {
        super.setUI()
        configHeaderView()
        addObserver()
        configClickAction()
    }
    
    private func configClickAction(){
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
    
    func goOrder(type:Int) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
        vc.selectIndex = type
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configHeaderView(){
        headerView       = WOWUserTopView()     
        headerView.frame = CGRectMake(0, 0, MGScreenWidth, 75)
        headerView.configShow(WOWUserManager.loginStatus)
        headerView.topContainerView.addAction {[weak self] in
            if let strongSelf = self{
                if WOWUserManager.loginStatus{
                    strongSelf.goUserInfo()
                }else{
                    strongSelf.toLoginVC(true)
                }
            }
        }
        configUserInfo()
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = headerView
    }
    
    private func goUserInfo(){
        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWUserInfoController)) as! WOWUserInfoController
        vc.editInfoAction = { [weak self] in
            if let strongSelf = self{
                strongSelf.configUserInfo()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configUserInfo(){
        if WOWUserManager.loginStatus {
            headerView.headImageView.kf_setImageWithURL(NSURL(string:WOWUserManager.userHeadImageUrl)!, placeholderImage:UIImage(named: "placeholder_userhead"))
            headerView.nameLabel.text = WOWUserManager.userName
            headerView.desLabel.text  = WOWUserManager.userDes
        }else{
            headerView.headImageView.image = UIImage(named: "placeholder_userhead")
        }
    }
    
    
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(loginSuccess), name:WOWLoginSuccessNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(exitLogin), name:WOWExitLoginNotificationKey, object:nil)

    }
    
//MARK:Actions
    func exitLogin() {
        configHeaderView()
    }
    
    func loginSuccess(){
        configHeaderView()
    }
}


//MARK:Delegate
extension WOWUserController:SKStoreProductViewControllerDelegate{
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section,indexPath.row) {
        case (1,2): //打电话
            WOWTool.callPhone()
            return
        case (1,4): //支持尖叫设计
            evaluateApp()
            return
        default:
            break
        }
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        switch (indexPath.section,indexPath.row){
        case let (1,row):
            switch row {
            case 0://优惠券
                let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
                vc.entrance = couponEntrance.userEntrance
                navigationController?.pushViewController(vc, animated: true)
            case 1://邀请好友
                let vc = UIStoryboard.initialViewController("User", identifier: "WOWInviteController")
                navigationController?.pushViewController(vc, animated: true)
            case 3: //意见反馈
                goLeavaTips()
            default:
                break
            }
        case (2,_)://设置
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWSettingController)) as! WOWSettingController
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    private func goLeavaTips(){
        let vc = UIStoryboard.initialViewController("User", identifier: String(WOWLeaveTipsController))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func evaluateApp(){
        let url = NSURL(string:"https://itunes.apple.com/cn/app/jian-jiao-she-ji/id1110300308?mt=8")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
