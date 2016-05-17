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
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //FIXME:为了让动画出现 所以多reload一次咯
        tableView.reloadData()
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
//        let sideVC = appdelegate.sideController.sideController as! WOWLeftSideController
//        sideVC.delegate = self
        tableView.mj_header = mj_header
    }

   
    private func configBarItem(){
        /*菜单暂时不需要
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
         */
        makeCustomerImageNavigationItem("search", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
//MARK:Actions

    
//MARK:Private Networkr
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_Sence, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.dismiss()
                strongSelf.endRefresh()
                let arr1 = Mapper<WOWSenceModel>().mapArray(result)
                if let arr2 = arr1{
                    strongSelf.dataArr = []
                    strongSelf.dataArr += arr2
                    strongSelf.tableView.reloadData()
                }
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
}


extension WOWController:LeftSideProtocol{
    func sideMenuSelect(tagString: String!, index: Int,dataArr:[WOWCategoryModel]) {
       let tab = WOWTool.appTabBarController
        tab.selectedIndex = 1
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
        vc.categoryIndex    = index
        vc.categoryTitles   = categoryTitles
        vc.categoryID       = WOWRealm.objects(WOWCategoryModel)[index].categoryID
        vc.categoryArr      = dataArr
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
        let scene = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
        let model       = dataArr[indexPath.row]
        scene.sceneID   = model.id
        scene.hideNavigationBar = true
        navigationController?.pushViewController(scene, animated: true)
    }
    
}

extension WOWController:SenceCellDelegate{
    func senceProductClick(produtID: String) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        vc.productID = produtID
        navigationController?.pushViewController(vc, animated: true)
    }
}



