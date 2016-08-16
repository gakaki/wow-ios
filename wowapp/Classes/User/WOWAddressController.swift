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
        vc.addressEntrance = AddressEntrance.addAddress
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
        navigationItem.title = "收货地址"
    }
    

 
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Addresslist, successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let arr = Mapper<WOWAddressListModel>().mapArray(JSON(result)["shippingInfoResultList"].arrayObject)
                if let array = arr{
                    strongSelf.dataArr = []
                    strongSelf.dataArr.appendContentsOf(array)
                    strongSelf.tableView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
    //选择默认地址
    func checkDefaut(sender:UIButton) {
        let model = dataArr[sender.tag]
        //如果这个地址本来就是默认的就不进这个方法
        guard model.isDefault!  else {
            let addressId = model.id ?? 0
            
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressSetDefault(id: addressId), successClosure: {[weak self] (result) in
                if let strongSelf = self{
                    for model:WOWAddressListModel in strongSelf.dataArr {
                        model.isDefault = false
                    }
                    model.isDefault = true
                    strongSelf.tableView.reloadData()
                }
            }) { (errorMsg) in
                
            }
            
            return
        }
        
    }
    //删除收货地址
    func deleteAddress(indexPath:NSIndexPath) {
        let model = self.dataArr[indexPath.section]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDelete(id:model.id ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.dataArr.removeAtIndex(indexPath.section)
                strongSelf.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
                strongSelf.tableView.reloadData()
            }
        }) {(errorMsg) in
            
        }
    }
}


extension WOWAddressController:UITableViewDelegate,UITableViewDataSource{
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataArr.count
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWAddressCell", forIndexPath:indexPath) as! WOWAddressCell
        switch entrance {
        case .SureOrder:
            cell.checkButton.hidden = false

            if let selModel = selectModel{
                let model = dataArr[indexPath.section]
                cell.checkButton.selected = (model.id == selModel.id)
            }
            case .Me:
            cell.checkButton.hidden = false
        }
        cell.checkButton.tag = indexPath.section
        cell.checkButton.addTarget(self, action: #selector(checkDefaut(_:)), forControlEvents:.TouchUpInside)
        
        cell.editButton.tag = indexPath.section
        cell.editButton.addTarget(self, action: #selector(editAddress(_:)), forControlEvents:.TouchUpInside)
        
        cell.showData(dataArr[indexPath.section])

        return cell
    }

    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if entrance == .SureOrder {
            if let ac = action{
                ac(object: dataArr[indexPath.section])
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
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
     func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
      
        let delete = UITableViewRowAction(style: .Default, title: "删除") { [weak self](action, indexPath) in
            if let strongSelf = self {
                strongSelf.alertView(indexPath)
            }
        }
        return [delete]
    }
    
    

    
    func editAddress(sender:UIButton) {
        let model = dataArr[sender.tag]
         let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        vc.addressModel = model
        vc.addressEntrance     = AddressEntrance.editAddress
        vc.action = {[weak self] in
            if let strongSelf = self{
                strongSelf.request()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

}


extension WOWAddressController{
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "你还没添加收货地址"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.systemScaleFontSize(17)])
        return attri
    }
    
    
    func alertView(indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "", message: "确定删除收货地址？", preferredStyle: .Alert)
        let cancel = UIAlertAction(title:"取消", style: .Cancel, handler: { (action) in
            DLog("取消")
        })
        
        let sure   = UIAlertAction(title: "确定", style: .Default) {[weak self] (action) in
            if let strongSelf = self{
                strongSelf.deleteAddress(indexPath)
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)

    }
}






