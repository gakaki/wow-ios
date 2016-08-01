//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import JSONCodable
enum AddressEntrance {
    case addAddress
    case editAddress
}

class WOWAddAddressController: WOWBaseTableViewController {
    @IBOutlet weak var nameTextField        : UITextField!
    @IBOutlet weak var phoneTextField       : UITextField!
    @IBOutlet weak var cityTextField        : UITextField!
    @IBOutlet weak var streeTextField       : UITextField!
    @IBOutlet weak var detailAddressTextView: KMPlaceholderTextView!
    @IBOutlet weak var footView             : UIView!
    @IBOutlet weak var selectButton         : UIButton!
    private var defaultAddress:Bool         = true
    
    var data:VoSldData                      = VoSldData()
    var addressEntrance:AddressEntrance            = .addAddress
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var districtIndex = 0

    
    
    var action:WOWActionClosure?
    
    
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
    }
    
    func loadJson(){
        if let path = NSBundle.mainBundle().pathForResource("city", ofType: "json") {
            
            do {
                let json_str    = try! String(contentsOfURL: NSURL(fileURLWithPath: path), encoding: NSUTF8StringEncoding)
                data = try! VoSldData(JSONString:json_str)
            } catch let error as NSError {
                print(error.localizedDescription)
            }catch {
                print("error")
            }
        } else {
            print("Invalid filename/path.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func setUI() {
        super.setUI()
        switch addressEntrance {
        case .addAddress:
            navigationItem.title = "新增收货地址"
        case .editAddress:
            navigationItem.title = "编辑收货地址"
        }
        navigationItem.leftBarButtonItems = nil
        tableView.keyboardDismissMode = .OnDrag
        tableView.tableFooterView = footView
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
        loadJson()
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
            let status = model.isDefault
            if status == 1 {
                defaultAddress = true
                selectButton.setImage(UIImage(named: "select"), forState: .Normal)
            }else {
                defaultAddress = false
                selectButton.setImage(UIImage(named: "car_check"), forState: .Normal)
            }
        }
        
    }
    
    
    
    private func configPicker(){
        pickerContainerView.pickerView.delegate = self
        pickerContainerView.pickerView.dataSource = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(sure), forControlEvents:.TouchUpInside)
        
        cityTextField.inputView = pickerContainerView
    }
    
    func cancel(){
        print("cancel")
        cityTextField.resignFirstResponder()
    }
    
    func sure() {
        cityTextField.resignFirstResponder()

        //获取选中的省
        let province = self.data.provinces[provinceIndex]
        
        //获取选中的市
        let cities      = self.data.getSubCities(province)
        if ( cities.count <= 0) { //没有找到城市的问题其实还是需要从源头json上处理的
            //消息显示
            let alertController = UIAlertController(title: "出错没有找到城市",
                                                    message: "出错没有找到城市", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let city        = cities[cityIndex]
        
        //获取选中的县（地区）
        let districts   = self.data.getSubDistricts(city)
        let district    = districts[districtIndex]
        
        //拼接输出消息
//        let message = "索引：\(provinceIndex)-\(cityIndex)-\(districtIndex)\n"
//            + "值：\(province.name) - \(city.name) - \(district.name)"
        
        let message = "\(province.name) - \(city.name) - \(district.name)"

        
        cityTextField.text = message
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFontOfSize(15)
        pickerLabel.numberOfLines = 0
        pickerLabel.textAlignment = .Center
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel
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
        let is_def  = defaultAddress ? "1" : "0"

        var addressdid = ""
        if let model = addressModel {
            addressdid = String(model.id) ?? ""
        }

        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressAdd(receiverName: name, provinceId: province ?? "", cityId: city ?? "", addressDetail: detailAddress, receiverMobile: phoneTextField.text ?? "", isDefault: is_def), successClosure: { [weak self](result) in
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
//        if let model = addressModel{
//            if model.isDefault == 1{
//                return 1
//            }
//        }
        return 1
    }
    
    
//MARK:Actions
    @IBAction func selectButton(sender: UIButton) {
        defaultAddress = !defaultAddress
        if defaultAddress {
            sender.setImage(UIImage(named: "select"), forState: .Normal)
        }else {
            sender.setImage(UIImage(named: "car_check"), forState: .Normal)
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            return self.data.provinces.count
        case 1:
            let province    = self.data.provinces[provinceIndex]
            let cities      = self.data.getSubCities(province)
            return cities.count
        case 2:
            
            let province    = self.data.provinces[provinceIndex]
            let cities      = self.data.getSubCities(province)
            if ( cities.count <= 0 ){
                return 0
            }
            let  city       = cities[cityIndex]
            let districts   = self.data.getSubDistricts(city)
            return districts.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch (component) {
        case 0:
            let province    = self.data.provinces[row]
            return province.name
        case 1:
            let province    = self.data.provinces[provinceIndex]
            let cities      = self.data.getSubCities(province)
            let city        = cities[row]
            return city.name
        case 2:
            let province    = self.data.provinces[provinceIndex]
            let cities      = self.data.getSubCities(province)
            let city        = cities[cityIndex]
            let districts   = self.data.getSubDistricts(city)
            if ( districts.count > 0) {
                let district    = districts[row]
                return district.name
            }else{
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //根据列、行索引判断需要改变数据的区域
        
        switch (component) {
        case 0:
            
            provinceIndex = row;
            cityIndex = 0;
            districtIndex = 0;
            pickerView.reloadComponent(1);
            pickerView.selectRow(0, inComponent: 1, animated: false);
            
            // reselect 1st area
            
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false);
            
        case 1:
            
            cityIndex           = row;
            districtIndex      = 0;
            
            // reselect 1st area
            pickerView.reloadComponent(2);
            pickerView.selectRow(0, inComponent: 2, animated: false);
            
        case 2:
            districtIndex      = row;
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
