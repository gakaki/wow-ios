//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import JSONCodable
import IQKeyboardManagerSwift
enum AddressEntrance {
    case addAddress
    case editAddress
}

class WOWAddAddressController: WOWBaseTableViewController {
    @IBOutlet weak var nameTextField        : UITextField!
    @IBOutlet weak var phoneTextField       : UITextField!
    @IBOutlet weak var cityTextField        : UITextField!
    @IBOutlet weak var detailAddressTextView: KMPlaceholderTextView!
    @IBOutlet weak var footView             : UIView!
    @IBOutlet weak var selectButton         : UIButton!
    @IBOutlet weak var warnImg1              : UIImageView!
    @IBOutlet weak var warnImg2              : UIImageView!
    @IBOutlet weak var warnImg3              : UIImageView!
    @IBOutlet weak var warnImg4              : UIImageView!
    private var defaultAddress:Bool         = false
    
    var data:VoSldDataOM! //城市三联动选择数据
    
    var addressEntrance:AddressEntrance?
    
    //选择的省索引
    var provinceIndex = 0
    //选择的市索引
    var cityIndex = 0
    //选择的县索引
    var districtIndex = 0

    
    
    var action:WOWActionClosure?
    
    
    //net param
    var provinceId:Int?     = 0
    var cityId:Int?         = 0
    var countyId:Int?      = 0
    var addressInfo        = WOWAddressListModel()
    
    
//    var addressModel : WOWAddressListModel?
    var entrance:WOWAddressEntrance = .Me
    
    lazy var pickerContainerView :WOWPickerView = {
        let v = NSBundle.mainBundle().loadNibNamed("WOWPickerView", owner: self, options: nil).last as! WOWPickerView
        return v
    }()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:#selector(viewTap(_:)))
//
//        cell.productImg.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(gesture)
    }
    func viewTap(sender:UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        detailAddressTextView.resignFirstResponder()
//        self.lookBigImg((sender.view?.tag)!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func setUI() {
        super.setUI()
        switch addressEntrance! {
        case .addAddress:
            navigationItem.title = "新增收货地址"
        case .editAddress:
            navigationItem.title = "编辑收货地址"
            configEditData()
        }
        navigationItem.leftBarButtonItems = nil
        tableView.keyboardDismissMode = .OnDrag
        tableView.tableFooterView = footView

        makeCustomerNavigationItem("保存", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.saveAddress()
            }
        }
        
        
        self.data = CityDataManager.data
        self.configPicker()
    }
    
    private func configEditData(){
//        if let model = addressInfo{
            provinceId = addressInfo.provinceId
            cityId = addressInfo.cityId
            countyId = addressInfo.countyId
            
        
            nameTextField.text  = addressInfo.name
            phoneTextField.text = addressInfo.mobile
            cityTextField.text = "\(addressInfo.province ?? "") - \(addressInfo.city ?? "") - \(addressInfo.county ?? "")"
            detailAddressTextView.text = addressInfo.addressDetail ?? ""
            defaultAddress = addressInfo.isDefault ?? false
            selectButton.selected = defaultAddress
//        }
        
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
        let province    = self.data.provinces[provinceIndex]
        
        //获取选中的市
        let cities      = province.subCities!
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
        let districts   = city.subDistricts!
        let district    = districts[districtIndex]
        
        //拼接输出消息
//        let message = "索引：\(provinceIndex)-\(cityIndex)-\(districtIndex)\n"
//            + "值：\(province.name) - \(city.name) - \(district.name)"
        
        let message = "\(province.name) - \(city.name) - \(district.name)"
        addressInfo.provinceId = (province.id)!.toInt()
        addressInfo.cityId = (city.id)!.toInt()
        addressInfo.countyId = (district.id)!.toInt()
        
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
        warnImg1.hidden = true
        warnImg2.hidden = true
        warnImg3.hidden = true
        warnImg4.hidden = true
        let name = nameTextField.text ?? ""
        if name.isEmpty {
            WOWHud.showMsg("请输入姓名")
            warnImg1.hidden = false
            return
        }
        if !validatePhone(phoneTextField.text) {
            warnImg2.hidden = false
            return
        }
        guard let c = cityTextField.text where !c.isEmpty else{
            WOWHud.showMsg("请选择省市区")
            warnImg3.hidden = false
            return
        }
        let detailAddress = detailAddressTextView.text
        if detailAddress.isEmpty {
            WOWHud.showMsg("请填写详细地址")
            warnImg4.hidden = false
            return
        }
        
        addressInfo.name = name
        addressInfo.mobile = phoneTextField.text
        addressInfo.addressDetail = detailAddress
        addressInfo.isDefault  = defaultAddress
        
        switch addressEntrance! {
        case .addAddress:
            addAddress(addressInfo)
        case .editAddress:
            editAddress(addressInfo)
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
        sender.selected = defaultAddress
        
    }
    
    //MARK: - Net 
    func addAddress(parameters:WOWAddressListModel) -> Void {
   
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressAdd(receiverName: parameters.name!, provinceId:parameters.provinceId ?? 0 , cityId: parameters.cityId ?? 0, countyId: parameters.countyId ?? 0, addressDetail: parameters.addressDetail ?? "", receiverMobile: parameters.mobile!, isDefault: parameters.isDefault ?? false), successClosure: { [weak self](result) in
            if let strongSelf = self{
                if let ac = strongSelf.action{
                    ac()
                    strongSelf.navigationController?.popViewControllerAnimated(true)
                    
                }
            }
        }) { (errorMsg) in
            
        }

    }
    
    func editAddress(parameters:WOWAddressListModel) -> Void {
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressEdit(id:parameters.id ?? 0 ,receiverName: parameters.name!, provinceId:parameters.provinceId ?? 0 , cityId: parameters.cityId ?? 0, countyId: parameters.countyId ?? 0, addressDetail: parameters.addressDetail ?? "", receiverMobile: parameters.mobile!, isDefault: parameters.isDefault ?? false), successClosure: { [weak self](result) in
            if let strongSelf = self{
                if let ac = strongSelf.action{
                    ac()
                    strongSelf.navigationController?.popViewControllerAnimated(true)
                    
                }
            }
        }) { (errorMsg) in
            
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
            let cities      = province.subCities!
            return cities.count
        case 2:
            
            let province    = self.data.provinces[provinceIndex]
            let cities      = province.subCities!
            if ( cities.count <= 0 ){
                return 0
            }
            let  city       = cities[cityIndex]
            let districts   = city.subDistricts!
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
            let cities      = province.subCities!
            let city        = cities[row]
            return city.name
        case 2:
            let province    = self.data.provinces[provinceIndex]
            let cities      = province.subCities!
            let city        = cities[cityIndex]
            let districts   = city.subDistricts!
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
