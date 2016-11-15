//
//  WOWHotStyleMain.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHotStyleMain: WOWBaseModuleVC {
    let cellID      = String(describing: WOWHotStyleCell.self)
    var dataArr     = [WOWHomeModle]()    //商品列表数组
    
    @IBOutlet var dataDelegate: WOWTableDelegate?
    
    @IBOutlet var tableView: UITableView!
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
        self.title = "精选"
        // Do any additional setup after loading the view.
        request()
        addObserver()
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        tableView.mj_header          = mj_header
        dataDelegate?.vc = self
        dataDelegate?.tableView = tableView
        
    }
    //  // 移除 cell for row 里面不存在的cellType类型，防止新版本增加新类型时，出现布局错误
    func screenConfigModule() {
        for model in self.dataArr {
            switch model.moduleType ?? 0 {
            case 701:
                break
            default:
                
                self.dataArr.removeObject(model)
            }
        }
    }

    override func request() {
        super.request()
        var params = [String: AnyObject]()
        
        params = ["pageId": 3 as AnyObject]

        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
                
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                    strongSelf.screenConfigModule()
                }
                strongSelf.dataDelegate?.dataSourceArray = strongSelf.dataArr
                strongSelf.tableView.reloadData()
                    WOWHud.dismiss()

                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        

    }
    
    fileprivate func addObserver(){
        // 刷新购物车数量
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
         NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(loginSuccess), name:NSNotification.Name(rawValue: WOWUpdateProjectThumbNotificationKey), object:nil)
        
    }
    func loginSuccess()  {// 重新刷新数据
        request()
    }
    func exitLogin()  {// 重新刷新数据
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
