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
    
    @IBOutlet weak var allOrderView: UIView!
    @IBOutlet weak var noPayView: UIView!
    @IBOutlet weak var noSendView: UIView!
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
            goLogin()
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
                    strongSelf.goLogin()
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
    
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
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
        guard WOWUserManager.loginStatus else{
            goLogin()
            return
        }
        switch (indexPath.section,indexPath.row){
        case let (1,row):
            switch row {
            case 1://邀请好友
                let vc = UIStoryboard.initialViewController("User", identifier: "WOWInviteController")
                navigationController?.pushViewController(vc, animated: true)
            case 2://打电话
                WOWTool.callPhone()
            case 4://支持尖叫设计
                evaluateApp()
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
    
    private func evaluateApp(){
        let vc = SKStoreProductViewController()
        vc.delegate = self
        vc.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier:"1110300308"], completionBlock: nil)
        self.presentViewController(vc, animated: true, completion: nil)
//        vc.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier:"1110300308"]) { (ret, error) in
//            if let e = error{
//                DLog(e)
//            }else{
//               
//            }
//        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
