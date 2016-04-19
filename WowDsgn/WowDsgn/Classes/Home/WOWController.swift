//
//  WOWController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWController: WOWBaseViewController {
    let cellID = String(WOWlListCell)
    var dataArr = [WOWSenceModel]()
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Lazy
    lazy var appdelegate:AppDelegate = {
        let a =  UIApplication.sharedApplication().delegate as! AppDelegate
        return a
    }()
    
//MARK:Private Method
    override func setUI() {
        navigationItem.title = "尖叫设计"
        tableView.registerNib(UINib.nibName(String(WOWlListCell)), forCellReuseIdentifier:cellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
        configBarItem()
        let sideVC = appdelegate.sideController.sideController as! WOWLeftSideController
        sideVC.delegate = self
        tableView.mj_header = mj_header
    }

    
    private func configBarItem(){
        makeCustomerImageNavigationItem("menu", left: true) {[weak self] () -> () in
            if let strongSelf = self{
                let sideVC = strongSelf.appdelegate.sideController
                if sideVC.showing{//显示中
                    sideVC.hideSide()
                }else{//隐藏中
                    sideVC.showSide()
                }
            }
        }
        
        makeCustomerImageNavigationItem("search", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
//MARK:Actions

    
//MARK:Private Network
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Sence("pageIndex",pageIndex), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                let arr1 = Mapper<WOWSenceModel>().mapArray(result)
                if let arr2 = arr1{
                    strongSelf.dataArr += arr2
                    strongSelf.tableView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
}


extension WOWController:LeftSideProtocol{
    func sideMenuSelect(tagString: String!, index: Int) {
        DLog(tagString)
       let tab = WOWTool.appTab
        tab.selectedIndex = 1
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
        vc.menuIndex = index
        vc.menuTitles = categoryTitles
        let nav = tab.selectedViewController as! WOWNavigationController
        nav.pushViewController(vc, animated: true)
    }
    
    var categoryTitles:[String]{
        get{
            let categorys = WOWRealm.objects(WOWCategoryModel)
            return categorys.map { (model) -> String in
                return model.categoryName
            }
        }
    }
}



extension WOWController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWlListCell
        cell.delegate = self
        let model = dataArr[indexPath.row]
        cell.showData(model)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
        sence.hideNavigationBar = true
        navigationController?.pushViewController(sence, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as! WOWlListCell
        cell.startAnimate()
    }
}

extension WOWController:SenceCellDelegate{
    func senceProductClick(produtID: String) {
        DLog("选择了id为\(produtID)的商品")
    }
}



