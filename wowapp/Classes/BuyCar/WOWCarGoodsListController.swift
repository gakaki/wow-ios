//
//  WOWCarGoodsListController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWCarGoodsListController: WOWBaseTableViewController {
    
    var productArr:[WOWBuyCarModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "商品清单"
        makeCustomerNavigationItem("共\(productArr.count)件", left: false, handler: nil)
        tableView.registerNib(UINib.nibName(String(WOWBuyCarNormalCell)), forCellReuseIdentifier:"WOWBuyCarNormalCell")
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = 108
    }
    
    
    
}


extension WOWCarGoodsListController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWBuyCarNormalCell", forIndexPath: indexPath) as! WOWBuyCarNormalCell
//        cell.hideLeftCheck()
        cell.showData(productArr[indexPath.row])
        return cell
    }
    
}