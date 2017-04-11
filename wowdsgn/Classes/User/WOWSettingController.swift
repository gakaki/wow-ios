//
//  WOWSettingController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import WebKit

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

    
//MARK:Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch WOWUserManager.loginStatus {
        case true:
            return 2
        case false:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0 {
                VCRedirect.goUserInfo()

            }
            if (indexPath as NSIndexPath).row == 1 {
         
                let cache = KingfisherManager.shared.cache
                
                cache.clearDiskCache(completion: {
                    WOWHud.showMsg("清除成功")
                })
                cache.cleanExpiredDiskCache()
                cache.clearMemoryCache()
                KingfisherManager.shared.cache.calculateDiskCacheSize(completion: { (size) in
                    print("disk size in bytes: \(size)")

                })
                
                //清楚yywebimage cache
                if let c  = YYWebImageManager.shared().cache{
                    // get cache capacity
                    DLog("memoryCache.totalCost is \(c.memoryCache.totalCost), memoryCache.totalCount is \(c.memoryCache.totalCount),diskCache.totalCost is \(c.diskCache.totalCost()),diskCache.totalCount is \(c.diskCache.totalCount())")
                    
                    // clear cache
                    c.memoryCache.removeAllObjects()
                    c.diskCache.removeAllObjects({
                        DLog("清除成功")
                    })

                }
                
               ClearCache()
                
            }
        case 1:
            alertExit()
        default:
            break
        }
    }

    func ClearCache() {
        
        //清除url的缓存
        URLCache.shared.removeAllCachedResponses()
        
        let dateFrom: Date = Date.init(timeIntervalSince1970: 0)
        
        if #available(iOS 9.0, *) {
            
            let websiteDataTypes: Set = WKWebsiteDataStore.allWebsiteDataTypes()
            
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
                
                DLog("清空WKWebView缓存完成")
                
            }
            
        }         
    }
    fileprivate func alertExit(){
        let alertController: UIAlertController = UIAlertController(title: "退出登录", message: nil, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style:.cancel, handler: nil)
        alertController.addAction(cancelAction)
        let sureAction: UIAlertAction = UIAlertAction(title: "确定", style: .default) { action -> Void in
            self.exitLogin()
        }
        alertController.addAction(sureAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    fileprivate func exitLogin(){
        WOWNetManager.sharedManager.requestWithTarget(.api_Logout, successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("退出登录")
                WOWUserManager.exitLogin()
                
                UIApplication.currentViewController()?.toLoginVC(true)
                strongSelf.tabBarController?.selectedIndex = 0
                strongSelf.tableView.reloadData()
                NotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                })
            }
        }) {[weak self] (errorMsg) in
            if self != nil{
                WOWHud.showMsg("退出登录失败")
            }
        }

        
    }
    
    func cancleWecha()  {
        
        WowShare.cancle { (con) in
            print("清楚微信缓存")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        default:
            return 25
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


