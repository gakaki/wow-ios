//
//  WOWCarGoodsListController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWCarGoodsListController: WOWBaseTableViewController {
    
    var productArr:[WOWCarProductModel]!
    
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
        tableView.register(UINib.nibName(String(describing: WOWBuyCarNormalCell.self)), forCellReuseIdentifier:"WOWBuyCarNormalCell")
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = 108
    }
    
    
    
}


extension WOWCarGoodsListController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWBuyCarNormalCell", for: indexPath) as! WOWBuyCarNormalCell
//        cell.showData(productArr[indexPath.row])
//        cell.hideLeftCheck()

        return cell
    }
    
}
