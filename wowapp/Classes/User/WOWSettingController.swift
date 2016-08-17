//
//  WOWSettingController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSettingController: WOWBaseTableViewController {

    @IBOutlet weak var cacheLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title  = "设置"
//        calCacheSize()
        
    }
    
//MARK:Private Method
    private func calCacheSize(){
        
        KingfisherManager.sharedManager.cache.calculateDiskCacheSizeWithCompletionHandler {[weak self](size) in
            if let strongSelf = self{
                let mSize = Float(size) / 1024 / 1024
                let str = String(format:"%.1f",mSize)
                strongSelf.cacheLabel.text = str + "m"
            }
        }
    }
    
    
//MARK:Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch WOWUserManager.loginStatus {
        case true:
            return 2
        case false:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
                vc.entrance = msgCodeEntrance.userEntrance
                navigationController?.pushViewController(vc, animated: true)
            }
            if indexPath.row == 1 {
                KingfisherManager.sharedManager.cache.clearDiskCacheWithCompletionHandler({[weak self] in
                    if let _ = self{
                        WOWHud.showMsg("清除成功")
//                        strongSelf.cacheLabel.text = "0.0m"
                    }
                })
            }
        case 1:
            alertExit()
        default:
            break
        }
    }
    
    
    private func alertExit(){
        let alertController: UIAlertController = UIAlertController(title: "退出登录", message: nil, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style:.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let sureAction: UIAlertAction = UIAlertAction(title: "确定", style: .Default) { action -> Void in
            self.exitLogin()
        }
        alertController.addAction(sureAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    private func exitLogin(){
        WOWUserManager.exitLogin()
        tableView.reloadData()
        NSNotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
        WOWHud.showMsg("退出登录")
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        default:
            return 25
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


