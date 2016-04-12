//
//  WOWActivityController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/2.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWActivityController: WOWBaseViewController {
    let cellID = String(WOWActivityListCell)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setUI() {
        super.setUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.registerNib(UINib.nibName(String(WOWActivityListCell)), forCellReuseIdentifier:cellID)
    }
}

extension WOWActivityController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME:测试数据
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWActivityListCell
        //FIXME:测试数据
        cell.pictureImageView.image = UIImage(named: "testActivity")
        return cell
    }
}
