//
//  WOWHotStyleMain.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/12.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWHotStyleMain: WOWBaseViewController {
    let cellID = String(WOWHotStyleCell)
      @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "精选"
        // Do any additional setup after loading the view.
        
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem(WOWUserManager.userCarCount)
        tableView.registerNib(UINib.nibName(String(WOWHotStyleCell)), forCellReuseIdentifier:cellID)
        self.tableView.backgroundColor = GrayColorLevel6
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
    }

      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension WOWHotStyleMain:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWHotStyleCell
        
//        cell.delegate       = self
        
//        cell.showData(model.moduleContent!)
        
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