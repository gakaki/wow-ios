//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAddAddressController: WOWBaseTableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var detailAddressTextField: UITextField!
    @IBOutlet weak var defaultSwitch: UISwitch!
    private var defaultAddress:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = "新增地址"
        navigationItem.leftBarButtonItems = nil
        tableView.keyboardDismissMode = .OnDrag
        makeCustomerNavigationItem("取消", left: true) {[weak self] in
            if let strongSelf = self{
                strongSelf.navigationController?.popViewControllerAnimated(true)
            }
        }
        makeCustomerNavigationItem("保存", left: false) {[weak self] in
            if let _ = self{
                DLog("保存")
            }
        }
    }
    
    
    
//MARK:Actions
    @IBAction func switchChanged(sender: UISwitch) {
        defaultAddress = sender.on
        DLog("默认地址")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
    }
}


extension WOWAddAddressController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}