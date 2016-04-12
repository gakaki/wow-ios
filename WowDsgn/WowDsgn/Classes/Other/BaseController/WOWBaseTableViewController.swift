//
//  WOWBaseTableViewController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/19.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWBaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func setUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
    }

}
