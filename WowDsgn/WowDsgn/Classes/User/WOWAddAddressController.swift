//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWAddAddressController: WOWBaseTableViewController {

    @IBOutlet weak var nameTextField        : UITextField!
    @IBOutlet weak var phoneTextField       : UITextField!
    @IBOutlet weak var cityTextField        : UITextField!
    @IBOutlet weak var detailAddressTextView: KMPlaceholderTextView!
    @IBOutlet weak var defaultSwitch        : UISwitch!
    private var defaultAddress:Bool         = true
    
    lazy var pickerView                     = UIPickerView()
    
    // properties
    var cities:NSArray?
    var districts:NSArray?
    var provinces:NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCityData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


        // Dispose of any resources that can be recreated.
    }
    

//MARK:Private Method
    private func getCityData() {
        self.provinces = NSMutableArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area", ofType: "plist")!)!
        self.cities = self.provinces!.objectAtIndex(0).objectForKey("cities") as? NSArray
        self.districts = cities?.objectAtIndex(0).objectForKey("areas") as? NSArray
    }

    
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
        configPicker()
    }
    
    private func configPicker(){
        let view = UIView(frame:CGRectMake(0, 0, MGScreenWidth, 290))
        view.backgroundColor = UIColor.whiteColor()
        let topView = UIView(frame:CGRectMake(0, 0, MGScreenWidth, 40))
        topView.backgroundColor = UIColor.whiteColor()
        view.addSubview(topView)
        
        let cancelButton = UIButton(type: .System)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitleColor(GrayColorlevel2, forState:.Normal)
        cancelButton.setTitle("取消", forState:.Normal)
        cancelButton.frame = CGRectMake(8, 0, 60, 40)
        cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        topView.addSubview(cancelButton)
        
        let sureButton = UIButton(type: .System)
        sureButton.setTitle("确定", forState:.Normal)
        sureButton.backgroundColor = UIColor.whiteColor()
        sureButton.setTitleColor(GrayColorlevel2, forState:.Normal)
        sureButton.frame = CGRectMake(MGScreenWidth - 68, 0, 60, 45)
        sureButton.addTarget(self, action:#selector(sure), forControlEvents:.TouchUpInside)
        topView.addSubview(sureButton)
        
        pickerView.frame = CGRectMake(0, 40, MGScreenWidth, 250)
        pickerView.backgroundColor      = GrayColorLevel5
        pickerView.delegate             = self
        pickerView.dataSource           = self
        view.addSubview(pickerView)
        cityTextField.inputView = view
    }
    
    func cancel(){
        cityTextField.resignFirstResponder()
    }
    
    func sure() {
        let provinceIndex   = pickerView.selectedRowInComponent(0)
        let cityIndex       = pickerView.selectedRowInComponent(1)
        let districtIndex   = pickerView.selectedRowInComponent(2)
        let p = self.provinces![provinceIndex].objectForKey("state") as? String
        let c = self.cities![cityIndex].objectForKey("city") as? String
        var d : String? = ""
        if self.districts?.count != 0 {
            d = self.districts![districtIndex] as? String
        }
        let address = (p ?? "") + (c ?? "") + (d ?? "")
        DLog("选择的地址\(address)")
        cityTextField.text = address
        cityTextField.resignFirstResponder()
    }
    
    
//MARK:Actions
    @IBAction func switchChanged(sender: UISwitch) {
        defaultAddress = sender.on
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




extension WOWAddAddressController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return (self.provinces != nil ? self.provinces!.count : 0)
        case 1:
            return (self.cities != nil ? self.cities!.count : 0)
        case 2:
            return (self.districts != nil ? self.districts!.count : 0)
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch (component) {
        case 0:
            return provinces?.objectAtIndex(row).objectForKey("state") as? String
            
        case 1:
            return cities?.objectAtIndex(row).objectForKey("city") as? String
        case 2:
            if (self.districts?.count > 0) {
                return self.districts?.objectAtIndex(row) as? String
            }
        default:
            return ""
        }
        return nil
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
        case 0:
            
            cities = provinces?.objectAtIndex(row).objectForKey("cities") as? NSArray
            
            // reselect 1st city
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            self.pickerView.reloadComponent(1)
            self.districts = cities?.objectAtIndex(0).objectForKey("areas") as? NSArray
            // reselect 1st area
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(2)
            
        case 1:
            self.districts = cities?.objectAtIndex(row).objectForKey("areas") as? NSArray
            // reselect 1st area
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(2)
        default:
            break
        }
    }
    
}