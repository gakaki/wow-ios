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
    var bottomListArray = [WOWHotStyleModel]() //精选底部列表数组
 
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
        self.title = "灵感"
        // Do any additional setup after loading the view.
        request()
        addObserver()
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        
        dataDelegate?.vc                    = self
        dataDelegate?.ViewControllerType    = ControllerViewType.HotStyle
        
        self.view.backgroundColor           = UIColor.white
        dataDelegate?.tableView.backgroundColor = UIColor.white
    }
    override func request() {
        super.request()
        self.requestTop()
        self.requestBottom()

    }
    func requestTop()  {
        var params = [String: AnyObject]()
        
        params = ["pageId": 4 as AnyObject]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params), successClosure: {[weak self](result, code) in
            WOWHud.dismiss()
            
            if let strongSelf = self{
                strongSelf.endRefresh()
                strongSelf.dataDelegate?.dataSourceArray    =    strongSelf.dataWithHomeModel(result: result)
                
                if let brandArray =  strongSelf.dataDelegate?.dataSourceArray{
                    
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                    
                }
                
//                if strongSelf.bottomListArray.count > 0 {// 确保reloadData 数据都存在
                
                    strongSelf.tableView.reloadData()
                    
//                }
 
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }

    }
    override func requestBottom()  {
        var params = [String: AnyObject]()
        
        let totalPage = 10
        params = ["currentPage": pageIndex as AnyObject,"pageSize":totalPage as AnyObject]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_HotStyle_BottomList(params : params), successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let json = JSON(result)
                DLog(json)
                strongSelf.mj_footerHome.endRefreshing()
                
                let bannerList = Mapper<WOWHotStyleModel>().mapArray(JSONObject:JSON(result)["topics"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.bottomListArray = []
                        strongSelf.dataDelegate?.isOverBottomData = false
                        
                    }
                    if bannerList.count < totalPage {// 如果拿到的数据，小于分页，则说明，无下一页
                        strongSelf.tableView.mj_footer = nil
                        strongSelf.dataDelegate?.isOverBottomData = true
                        
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footerHome
                    }
                    
                    strongSelf.bottomListArray.append(contentsOf: bannerList)
                    strongSelf.dataDelegate?.bottomHotListArray = strongSelf.bottomListArray
                    
                }else {
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.bottomListArray = []
                    }
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
//                if strongSelf.dataArr.count > 0 {// 确保reloadData 数据都存在
                
                    strongSelf.tableView.reloadData()
                    WOWHud.dismiss()
//                }

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
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData), name:NSNotification.Name(rawValue: WOWUpdateProjectThumbNotificationKey), object:nil)
        
    }
    
    func reloadData()  {
        tableView.reloadData()
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
