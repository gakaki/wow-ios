//
//  WOWHotStyleMain.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHotStyleMain: WOWBaseViewController {
    let cellID      = String(WOWHotStyleCell)
    var dataArr     = [WOWHomeModle]()    //商品列表数组
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "精选"
        // Do any additional setup after loading the view.
        request()
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        tableView.registerNib(UINib.nibName(String(WOWHotStyleCell)), forCellReuseIdentifier:cellID)
        self.tableView.backgroundColor = GrayColorLevel6
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = mj_header
        tableView.estimatedRowHeight = 410
    }
    override func request() {
        super.request()
        var params = [String: AnyObject]?()
        
        params = ["pageId": 3]
        
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_Home_List(params: params), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModle>().mapArray(JSON(result)["modules"].arrayObject)
                
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
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension WOWHotStyleMain:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArr.count;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWHotStyleCell
        
        let homeModel = dataArr[indexPath.section]
            
        cell.showData(homeModel)

        cell.selectionStyle = .None
        
        return cell

    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return CGFloat.min
        }else{
            return 15.h
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
      
        return CGFloat.min
        
        
    }
}