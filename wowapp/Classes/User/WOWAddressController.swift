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



class WOWAddressController: WOWBaseViewController {
    @IBOutlet weak var tableView:UITableView!
    var entrance:WOWAddressEntrance = .Me
    var dataArr = [WOWAddressListModel]()
    var action  : WOWObjectActionClosure?
    var selectModel : WOWAddressListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MAEK:Action
    @IBAction func addAddress(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        vc.action = {[weak self] in
            if let strongSelf = self{
                strongSelf.request()
            }
        }
  
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

//MARK:Private Method
    
     override func setUI() {
        super.setUI()
        tableView.registerNib(UINib.nibName(String(WOWAddressCell)), forCellReuseIdentifier: "WOWAddressCell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor
        navigationItem.title = "管理收货地址"
//        makeCustomerNavigationItem("增加地址", left: false) {[weak self] in
//            if let strongSelf = self{
//                let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
//                vc.action = {[weak self] in
//                    if let strongSelf = self{
//                        strongSelf.request()
//                    }
//                }
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    

 
//MARK:Network
    override func request() {
        super.request()
//        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Addresslist, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let arr = Mapper<WOWAddressListModel>().mapArray(result)
                if let array = arr{
                    strongSelf.dataArr = []
                    strongSelf.dataArr.appendContentsOf(array)
                    strongSelf.tableView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
}


extension WOWAddressController:UITableViewDelegate,UITableViewDataSource{
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 131
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWAddressCell", forIndexPath:indexPath) as! WOWAddressCell
        switch entrance {
        case .SureOrder:
            cell.checkButton.hidden = false

            if let selModel = selectModel{
                let model = dataArr[indexPath.row]
                cell.checkButton.selected = (model.id == selModel.id)
            }
            case .Me:
            cell.checkButton.hidden = false
        }
        cell.checkButton.tag = indexPath.row
        cell.checkButton.addTarget(self, action: #selector(checkDefaut(_:)), forControlEvents:.TouchUpInside)
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAddress(_:)), forControlEvents:.TouchUpInside)
        
        cell.showData(dataArr[indexPath.row])

        return cell
    }

    //选择默认地址
    func checkDefaut(sender:UIButton) {
        let model = dataArr[sender.tag]
        guard model.isDefault == 1 else {
            let addressId = model.id ?? 0
            
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDefault(id: String(addressId)), successClosure: {[weak self] (result) in
                if let strongSelf = self{
                    for model:WOWAddressListModel in strongSelf.dataArr {
                        model.isDefault = 0
                    }
                    
                    model.isDefault = 1
                    let section = NSIndexSet(index: 0)
                    
                    strongSelf.tableView.reloadSections(section, withRowAnimation: .Automatic)

                }
            }) { (errorMsg) in
                
            }
            
                return
        }
        
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if entrance == .SureOrder {
            if let ac = action{
                ac(object: dataArr[indexPath.row])
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.entrance == .SureOrder {
            return false
        }else{
            return true
        }
    }
    
//     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .Normal, title: "编辑") { (action, indexPath) in
//            self.editAddress(self.dataArr[indexPath.row])
//        }
//        let delete = UITableViewRowAction(style: .Default, title: "删除") { (action, indexPath) in
//            self.deleteAddress(self.dataArr[indexPath.row])
//        }
//        return [delete,edit]
//    }
    

    
    func editAddress(sender:UIButton) {
        let model = dataArr[sender.tag]
         let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        vc.addressModel = model
        vc.action = {[weak self] in
            if let strongSelf = self{
                strongSelf.request()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func deleteAddress(model:WOWAddressListModel) {
        let uid =  WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDelete(uid:uid, addressid:String(model.id) ?? ""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let json = JSON(result).int ?? 0
                if json == 1{
                    strongSelf.request()
                }
            }
        }) {(errorMsg) in
                
        }
    }
}


extension WOWAddressController{
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "你还没添加收货地址"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.systemScaleFontSize(17)])
        return attri
    }
}






