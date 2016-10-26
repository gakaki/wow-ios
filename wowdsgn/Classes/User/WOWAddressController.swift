//
//  WOWAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum WOWAddressEntrance {
    case  sureOrder
    case  me
}

protocol addressDelegate:class {
    func editAddress()
}


class WOWAddressController: WOWBaseViewController {
    @IBOutlet weak var tableView:UITableView!
    var entrance:WOWAddressEntrance = .me
    var dataArr = [WOWAddressListModel]()
    var action  : WOWObjectActionClosure?
    var selectModel : WOWAddressListModel?
    weak var delegate: addressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MAEK:Action
    @IBAction func addAddress(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        vc.addressEntrance = AddressEntrance.addAddress
        vc.action = {[weak self] in
            if let strongSelf = self{
                strongSelf.request()
                if let del = strongSelf.delegate {
                    del.editAddress()
                }
            }
        }
  
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

//MARK:Private Method
    
     override func setUI() {
        super.setUI()
        tableView.register(UINib.nibName(String(describing: WOWAddressCell.self)), forCellReuseIdentifier: "WOWAddressCell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = GrayColorLevel5
        self.tableView.separatorColor = SeprateColor
        navigationItem.title = "收货地址"
    }
    

 
//MARK:Network
    //收货地址列表
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Addresslist, successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let arr = Mapper<WOWAddressListModel>().mapArray(JSONObject:JSON(result)["shippingInfoResultList"].arrayObject)
                if let array = arr{
                    strongSelf.dataArr = []
                    strongSelf.dataArr.append(contentsOf: array)
                    strongSelf.tableView.reloadData()
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
    //选择默认地址
    func checkDefaut(_ sender:UIButton) {
        let model = dataArr[sender.tag]
        //如果这个地址本来就是默认的就不进这个方法
        guard model.isDefault!  else {
            let addressId = model.id ?? 0
            
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressSetDefault(id: addressId), successClosure: {[weak self] (result, code) in
                if let strongSelf = self{
                    for model:WOWAddressListModel in strongSelf.dataArr {
                        model.isDefault = false
                    }
                    model.isDefault = true
                    strongSelf.tableView.reloadData()
                    if let del = strongSelf.delegate {
                        del.editAddress()
                    }
                }
            }) { (errorMsg) in
                
            }
            
            return
        }
        
    }
    //删除收货地址
    func deleteAddress(_ indexPath:IndexPath) {
        let model = self.dataArr[(indexPath as NSIndexPath).section]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressDelete(id:model.id ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.dataArr.remove(at: (indexPath as NSIndexPath).section)
                strongSelf.tableView.deleteSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .fade)
                strongSelf.tableView.reloadData()
                if let del = strongSelf.delegate {
                    del.editAddress()
                }
            }
        }) {(errorMsg) in
            
        }
    }
    //编辑收货地址
    func editAddress(_ sender:UIButton) {
        let model = dataArr[sender.tag]
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAddAddressController") as! WOWAddAddressController
        vc.addressInfo = model
        vc.addressEntrance     = AddressEntrance.editAddress
        vc.action = {[weak self] in
            if let strongSelf = self{
                strongSelf.request()
                if let del = strongSelf.delegate {
                    del.editAddress()
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWAddressController:UITableViewDelegate,UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWAddressCell", for:indexPath) as! WOWAddressCell
        switch entrance {
        case .sureOrder:
            cell.checkButton.isHidden = false

            if let selModel = selectModel{
                let model = dataArr[(indexPath as NSIndexPath).section]
                cell.checkButton.isSelected = (model.id == selModel.id)
            }
            case .me:
            cell.checkButton.isHidden = false
        }
        cell.checkButton.tag = (indexPath as NSIndexPath).section
        cell.checkButton.addTarget(self, action: #selector(checkDefaut(_:)), for:.touchUpInside)
        
        cell.editButton.tag = (indexPath as NSIndexPath).section
        cell.editButton.addTarget(self, action: #selector(editAddress(_:)), for:.touchUpInside)
        
        cell.showData(dataArr[(indexPath as NSIndexPath).section])

        return cell
    }

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if entrance == .sureOrder {
            if let ac = action{
                ac(dataArr[(indexPath as NSIndexPath).section])
               _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.entrance == .sureOrder {
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
        let delete = UITableViewRowAction(style: .default, title: "删除") { [weak self](action, indexPath) in
            if let strongSelf = self {
                strongSelf.alertView(indexPath: indexPath)
            }
        }
        return [delete]
    }
    
    

    
    
    
    
    

}


extension WOWAddressController{
    func titleForEmptyDataSet( scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "你还没添加收货地址"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.systemScaleFontSize(17)])
        return attri
    }
    
    
    func alertView(indexPath: IndexPath) {
        let alert = UIAlertController(title: "", message: "确定删除收货地址？", preferredStyle: .alert)
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: { (action) in
            DLog("取消")
        })
        
        let sure   = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            if let strongSelf = self{
                strongSelf.deleteAddress(indexPath)
            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)

    }
}






