//
//  WOWHotStyleMain.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHotStyleMain: WOWBaseViewController {
    let cellID      = String(describing: WOWHotStyleCell.self)
    var dataArr     = [WOWHomeModle]()    //商品列表数组
    @IBOutlet var tableView: UITableView!
    
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
        tableView.register(UINib.nibName(String(describing: WOWHotStyleCell.self)), forCellReuseIdentifier:cellID)
        self.tableView.backgroundColor = GrayColorLevel5
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = mj_header
        tableView.estimatedRowHeight = 410
    }
    override func request() {
        super.request()
        var params = [String: AnyObject]()
        
        params = ["pageId": 3 as AnyObject]

        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
                
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
                    
                }
             
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
extension WOWHotStyleMain:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWHotStyleCell
        
        let homeModel = dataArr[(indexPath as NSIndexPath).section]
        cell.modelData = homeModel.moduleContentList
        cell.showData(homeModel)
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return CGFloat.leastNormalMagnitude
        }else{
            return 15.h
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
      
        return CGFloat.leastNormalMagnitude
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).section]
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
        //                vc.hideNavigationBar = true
        vc.topic_id = model.moduleContentList?.id ?? 0
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)

    }
}
extension WOWHotStyleMain:WOWHotStyleCellDelegate{
    
    func reloadTableViewDataWithCell(){
        request()
    }

}
extension WOWHotStyleMain:WOWHotStyleDelegate{
    
    func reloadTableViewData(){
        request()
    }

}
