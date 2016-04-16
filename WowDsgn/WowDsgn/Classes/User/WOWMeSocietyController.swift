//
//  WOWMeSocietyController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
 /// 关注我的和我关注的人的列表

enum SocietyType:String {
    case Focus = "关注"
    case Fans  = "粉丝"
}

class WOWMeSocietyController: WOWBaseViewController {
    var society:SocietyType = .Focus
    var dataArr = ["12","3","44","55"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        navigationItem.title = society.rawValue
        tableView.clearRestCell()
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = 66
        tableView.registerNib(UINib.nibName("WOWSocietyCell"), forCellReuseIdentifier:"WOWSocietyCell")
    }
}

extension WOWMeSocietyController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWSocietyCell", forIndexPath: indexPath) as! WOWSocietyCell
        cell.nameLabel.text = WOWTestStr
        cell.desLabel.text = WOWTestStr
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWUserHomeController") as! WOWUserHomeController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return society == .Focus
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataArr.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "取消关注"
    }
    
    
}
