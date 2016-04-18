//
//  WOWAboutController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAboutController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        navigationItem.title = "关于"
        view.backgroundColor = MGRgb(250, g: 250, b: 250)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = 45
        tableView.clearRestCell()
        let headerView = NSBundle.mainBundle().loadNibNamed("WOWAboutHeaderView", owner: self, options: nil).last as! WOWAboutHeaderView
        headerView.clipsToBounds = true
        headerView.frame = CGRectMake(0, 0, MGScreenWidth,250)
        tableView.tableHeaderView = headerView
    }

}



extension WOWAboutController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        let titles = ["尖叫用户使用协议","版权声明"]
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWCopyrightController") as! WOWCopyrightController
        switch indexPath.row {
        case 0:
            vc.navTitle = "使用协议"
        case 1:
            vc.navTitle = "版权声明"
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}