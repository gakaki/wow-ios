//
//  WOWAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum WOWAddressEntrance {
    case  SureOrder
    case  Me
}

class WOWAddressController: WOWBaseTableViewController {
    
    var entrance:WOWAddressEntrance = .Me
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//MARK:Private Method
    
     override func setUI() {
        super.setUI()
        tableView.registerNib(UINib.nibName(String(WOWAddressCell)), forCellReuseIdentifier: "WOWAddressCell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = "收获地址"
        configFooter()
         //FIXME:根据默认地址，再把勾打上
    }
    
    private func configFooter(){
        let footerView = WOWMenuTopView(leftTitle: "新增地址", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
        footerView.height = 40
        footerView.rightButton.setImage(UIImage(named:"address_add")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        footerView.addAction {[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController 
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
        tableView.tableFooterView = footerView
    }
    
//MARK:Actions
    func addAddress(){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension WOWAddressController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWAddressCell", forIndexPath:indexPath) as! WOWAddressCell
        switch entrance {
        case .SureOrder:
            cell.checkButton.hidden = false
        case .Me:
            cell.checkButton.hidden = true
            //FIXME:但是默认地址的那行得显示出来哦
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DLog("选择了地址")
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .Normal, title: "编辑") { (action, indexPath) in
            
        }
        let delete = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) in
            DLog("删除")
        }
        return [delete,edit]
    }
}


