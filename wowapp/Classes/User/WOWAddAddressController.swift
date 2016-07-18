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
    
    
    var action:WOWActionClosure?
    
    // properties
    var cities:NSArray?
    var districts:NSArray?
    var provinces:NSArray?
    
    //net param
    var province:String?    = ""
    var city:String?        = ""
    var district : String?  = ""
    
    var addressModel : WOWAddressListModel?
    var entrance:WOWAddressEntrance = .Me
    
    lazy var pickerContainerView :WOWPickerView = {
        let v = NSBundle.mainBundle().loadNibNamed("WOWPickerView", owner: self, options: nil).last as! WOWPickerView
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCityData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            if let strongSelf = self{
                strongSelf.saveAddress()
            }
        }
        configPicker()
        configEditData()
    }
    
    private func configEditData(){
        if let model = addressModel{
            province = model.province
            city = model.city
            district = model.district
            nameTextField.text  = model.name
            phoneTextField.text = model.mobile
            cityTextField.text = (model.province ?? "") + (model.city ?? "") + (model.district ?? "")
            detailAddressTextView.text = model.street ?? ""
            let status = (model.isDefault ?? 0) == 1
            defaultSwitch.setOn(status, animated: true)
        }
        
    }
    
    
    
    private func configPicker(){
        pickerContainerView.pickerView.delegate = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(sure), forControlEvents:.TouchUpInside)
        cityTextField.inputView = pickerContainerView
    }
    
    func cancel(){
        cityTextField.resignFirstResponder()
    }
    
    func sure() {
        let provinceIndex   = pickerContainerView.pickerView.selectedRowInComponent(0)
        let cityIndex       = pickerContainerView.pickerView.selectedRowInComponent(1)
        let districtIndex   = pickerContainerView.pickerView.selectedRowInComponent(2)
        province = self.provinces![provinceIndex].objectForKey("state") as? String
        city = self.cities![cityIndex].objectForKey("city") as? String
        if self.districts?.count != 0 {
            district = self.districts![districtIndex] as? String
        }
        let address = (province ?? "") + (city ?? "") + (district ?? "")
        cityTextField.text = address
        cityTextField.resignFirstResponder()
    }
    
//MARK:Network
    func saveAddress() {
        let name = nameTextField.text ?? ""
        if name.isEmpty {
            WOWHud.showMsg("请输入姓名")
            return
        }
        if !validatePhone(phoneTextField.text) {
            return
        }
        guard let c = city where !c.isEmpty else{
            WOWHud.showMsg("请选择省市区")
            return
        }
        let detailAddress = detailAddressTextView.text
        if detailAddress.isEmpty {
            WOWHud.showMsg("请填写详细地址")
            return
        }
        let is_def  = defaultSwitch.on ? "1" : "0"
        let uid = WOWUserManager.userID
        var addressdid = ""
        if let model = addressModel {
            addressdid = model.id ?? ""
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressAdd(uid:uid, name:name, province:province ?? "", city: city ?? "", district: district ?? "", street:detailAddress, mobile: phoneTextField.text ?? "", is_default: is_def,addressid:addressdid), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result).int
                if let ret = json{
                    if ret == 1{
                        WOWHud.showMsg("添加成功")
                        if let ac = strongSelf.action{
                            ac()
                            strongSelf.navigationController?.popViewControllerAnimated(true)
                        }
                    }else{
                        WOWHud.showMsg("添加失败")
                    }
                }
            }
        }) { (errorMsg) in
                
        }
        
    }
    
    
    private func validatePhone(phoneNumber:String?) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            return false
        }
        
        guard phone.validateMobile() else{
            WOWHud.showMsg("请输入正确的手机号")
            return false
        }
        return true
    }

//MARK:Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let model = addressModel{
            if model.isDefault == 1{
                return 1
            }
        }
        return 2
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
            self.pickerContainerView.pickerView.selectRow(0, inComponent: 1, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(1)
            self.districts = cities?.objectAtIndex(0).objectForKey("areas") as? NSArray
            // reselect 1st area
            self.pickerContainerView.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(2)
            
        case 1:
            self.districts = cities?.objectAtIndex(row).objectForKey("areas") as? NSArray
            // reselect 1st area
            self.pickerContainerView.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(2)
        default:
            break
        }
    }
}

extension WOWAddAddressController:UITextViewDelegate{
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
