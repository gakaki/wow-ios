//
//  WOWAddAddressController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
//import JSONCodable
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
    fileprivate var defaultAddress:Bool         = false
    
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
    var entrance:WOWAddressEntrance = .me
    
    lazy var pickerContainerView :WOWPickerView = {
        let v = Bundle.main.loadNibNamed("WOWPickerView", owner: self, options: nil)?.last as! WOWPickerView
        return v
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool) {
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
    func viewTap(_ sender:UITapGestureRecognizer) {
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
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = footView

        makeCustomerNavigationItem("保存", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.saveAddress()
            }
        }
        
        
        self.data = CityDataManager.data
        self.configPicker()
    }
    
    fileprivate func configEditData(){
//        if let model = addressInfo{
            provinceId = addressInfo.provinceId
            cityId = addressInfo.cityId
            countyId = addressInfo.countyId
            
        
            nameTextField.text  = addressInfo.name
            phoneTextField.text = addressInfo.mobile
            cityTextField.text = "\(addressInfo.province ?? "") - \(addressInfo.city ?? "") - \(addressInfo.county ?? "")"
            detailAddressTextView.text = addressInfo.addressDetail ?? ""
            defaultAddress = addressInfo.isDefault ?? false
            selectButton.isSelected = defaultAddress
//        }
        
    }
    
    
    
    fileprivate func configPicker(){
        pickerContainerView.pickerView.delegate = self
        pickerContainerView.pickerView.dataSource = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancel), for:.touchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(sure), for:.touchUpInside)
        
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
                                                    message: "出错没有找到城市", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let city        = cities[cityIndex]
        
        //获取选中的县（地区）
        let districts   = city.subDistricts!
        let district    = districts[districtIndex]
        
        //拼接输出消息
//        let message = "索引：\(provinceIndex)-\(cityIndex)-\(districtIndex)\n"
//            + "值：\(province.name) - \(city.name) - \(district.name)"
        
        let message = "\(province.name!) - \(city.name!) - \(district.name!)"
        addressInfo.provinceId = (province.id)!.toInt()
        addressInfo.cityId = (city.id)!.toInt()
        addressInfo.countyId = (district.id)!.toInt()
        
        cityTextField.text = message
    }
    
    @objc(pickerView:viewForRow:forComponent:reusingView:) func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFont(ofSize: 15)
        pickerLabel.numberOfLines = 0
        pickerLabel.textAlignment = .center
        pickerLabel.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return pickerLabel
    }
    
//MARK:Network
    func saveAddress() {
        warnImg1.isHidden = true
        warnImg2.isHidden = true
        warnImg3.isHidden = true
        warnImg4.isHidden = true
        let name = nameTextField.text ?? ""
        if name.isEmpty {
            WOWHud.showMsg("请输入姓名")
            warnImg1.isHidden = false
            return
        }
        if !validatePhone(phoneTextField.text) {
            warnImg2.isHidden = false
            return
        }
        guard let c = cityTextField.text , !c.isEmpty else{
            WOWHud.showMsg("请选择省市区")
            warnImg3.isHidden = false
            return
        }
        let detailAddress = detailAddressTextView.text
        if (detailAddress?.isEmpty)! {
            WOWHud.showMsg("请填写详细地址")
            warnImg4.isHidden = false
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
    
    
    fileprivate func validatePhone(_ phoneNumber:String?) -> Bool{
        guard let phone = phoneNumber , !phone.isEmpty else{
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
    override func numberOfSections(in tableView: UITableView) -> Int {
//        if let model = addressModel{
//            if model.isDefault == 1{
//                return 1
//            }
//        }
        return 1
    }
    
    
//MARK:Actions
    @IBAction func selectButton(_ sender: UIButton) {
        defaultAddress = !defaultAddress
        sender.isSelected = defaultAddress
        
    }
    
    //MARK: - Net 
    func addAddress(_ parameters:WOWAddressListModel) -> Void {
   
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressAdd(receiverName: parameters.name!, provinceId:parameters.provinceId ?? 0 , cityId: parameters.cityId ?? 0, countyId: parameters.countyId ?? 0, addressDetail: parameters.addressDetail ?? "", receiverMobile: parameters.mobile!, isDefault: parameters.isDefault ?? false), successClosure: { [weak self](result) in
            if let strongSelf = self{
                if let ac = strongSelf.action{
                    ac()
                  _ =  strongSelf.navigationController?.popViewController(animated: true)
                    
                }
            }
        }) { (errorMsg) in
            
        }

    }
    
    func editAddress(_ parameters:WOWAddressListModel) -> Void {
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressEdit(id:parameters.id ?? 0 ,receiverName: parameters.name!, provinceId:parameters.provinceId ?? 0 , cityId: parameters.cityId ?? 0, countyId: parameters.countyId ?? 0, addressDetail: parameters.addressDetail ?? "", receiverMobile: parameters.mobile!, isDefault: parameters.isDefault ?? false), successClosure: { [weak self](result) in
            if let strongSelf = self{
                if let ac = strongSelf.action{
                    ac()
                   _ = strongSelf.navigationController?.popViewController(animated: true)
                    
                }
            }
        }) { (errorMsg) in
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}


extension WOWAddAddressController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}






extension WOWAddAddressController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
