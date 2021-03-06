//
//  WOWRegistInfoSecondController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
/**
 点击事件类型
 
 - ageType:  点击选择年龄
 - starType: 点就选择星座
 */
enum ClickActionType {
    case ageType
    case starType
}


class WOWRegistInfoSecondController: WOWBaseTableViewController {
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    var editingTextField:UITextField?

    var isPresent:Bool = false
    var sex = 1
    var ageRow = Int(0)
    var starRow = Int(0)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.e(.Other_Linfropage_Reg)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        configTable()
        configNav()
        
    }
    //MARK:实例pickerView
    
//    fileprivate func configPickerView(){
    
//        backGroundMaskView = UIView()
//        backGroundMaskView.frame = CGRect(x: 0, y: 0 , width: MGScreenWidth, height: MGScreenHeight)
//        backGroundMaskView.backgroundColor = UIColor.black
//        backGroundMaskView.alpha = 0.2
//        
//        
//        
//        backGroundMaskView.addTapGesture(target: self, action: #selector(cancelPicker))
//        
//        pickerContainerView.frame = CGRect(x: 0, y: MGScreenHeight,width: UIApplication.currentViewController()?.view.w ?? MGScreenWidth, height: 250)
//        
//        
//        pickerContainerView.pickerView.delegate = self
//        
//        pickerContainerView.cancelButton.isHidden = false
//        pickerContainerView.sureButton.addTarget(self, action:#selector(surePicker), for:.touchUpInside)
//        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancel), for:.touchUpInside)
//        
//        
//        backGroundWindow = UIApplication.shared.keyWindow
//        
//        backGroundWindow.addSubview(backGroundMaskView)
//        backGroundWindow.addSubview(pickerContainerView)
//        backGroundMaskView.isHidden = true
//        
        
//    }
    
    fileprivate func configNav(){
        makeCustomerNavigationItem("跳过", left: false) {[weak self] in
            if let strongSelf = self{
                MobClick.e(UMengEvent.Bind_Other_Skip)
                
                if strongSelf.isPresent{
                    strongSelf.dismiss(animated: true, completion: nil)
                    UIApplication.appTabBarController.selectedIndex = 0
                }else {
                    //进入首页
                    VCRedirect.toMainVC()
                }
            }
        }
    }
    
    fileprivate func configTable(){
        let nextView = Bundle.main.loadNibNamed(String(describing: WOWRegistInfoSureView.self), owner: self, options: nil)?.last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(sure), for: .touchUpInside)
        nextView.sureButton.setTitle("完成", for: UIControlState())
        nextView.frame = CGRect(x: 0,y: 0, width: self.view.w, height: 200)
        tableView.tableFooterView = nextView
    }
    
    
//    //MARK:Actions
//    func cancelPicker(){
//        ageTextField.resignFirstResponder()
//        starTextField.resignFirstResponder()
//        
//        self.backGroundMaskView.isHidden = true
//        UIView.animate(withDuration: 0.3){
//            self.pickerContainerView.mj_y = MGScreenHeight
//        }
//        
//    }
//    
//    func surePicker() {
//        let row = pickerContainerView.pickerView.selectedRow(inComponent: 0)
//        
//        let currentType = clickType
//        switch currentType {// 星座下标从1开始，所以，做＋1处理 ，性别从1开始，默认为1，年龄从0开始
//            
//        case .ageType:
//            ageRow = row
//            ageTextField?.text = pickDataArr[row]
//        case .starType:
//            starRow = row + 1
//            starTextField?.text = pickDataArr[row + 1]
//            
//        }
//        
//        cancelPicker()
//    }
//    
//    
//    func cancel() {
//        self.backGroundMaskView.isHidden = true
//        UIView.animate(withDuration: 0.3){
//            self.pickerContainerView.mj_y = MGScreenHeight
//        }
//
//    }

    func sure() {
        
        MobClick.e(UMengEvent.Bind_Other_Succ)

        let params = ["sex":String(sex),"ageRange":String(ageRow),"constellation":String(starRow),"industry":jobTextField.text ?? ""]
        WOWNetManager.sharedManager.requestWithTarget(.api_Change(param:params ), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                DLog(result)
                //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
                WOWUserManager.userSex = strongSelf.sex
                WOWUserManager.userConstellation = strongSelf.starRow
                WOWUserManager.userAgeRange = strongSelf.ageRow
                WOWUserManager.userIndustry = strongSelf.jobTextField.text ?? ""
                
                VCRedirect.toLoginSuccess(strongSelf.isPresent)
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                WOWHud.showWarnMsg(errorMsg)
            }
        }
        
    }
    /**
     点击年龄选择按钮
     
     */
    @IBAction func ageClick(_ sender: UIButton){
        jobTextField.resignFirstResponder()
        
        VCRedirect.prentPirckerMask(dataArr: WOWAgeRange, startIndex: ageRow, block: {[unowned self] (str, index) in
            self.ageRow = index
            
            self.ageTextField?.text = str
            
        })
//        clickType = ClickActionType.ageType
////        pickDataArr = WOWAgeRange
//        
//        self.pickerContainerView.pickerView.reloadComponent(0)
//        pickerContainerView.pickerView.selectRow(ageRow, inComponent: 0, animated: true)
//        self.pickerContainerView.pickerView.reloadComponent(0)
//        showPickerView()
//        jobTextField.resignFirstResponder()
    }
    /**
     点击星座选择按钮
     
     */
    @IBAction func starClick(_ sender: UIButton){
        jobTextField.resignFirstResponder()

        let index: Int = starRow - 1 < 0 ? 0 : starRow - 1
        
        VCRedirect.prentPirckerMask(dataArr: WOWConstellation, startIndex: index, block: {[unowned self] (str, index) in
            self.starRow = index + 1
            
            self.starTextField?.text = str
            
        })

//        clickType = ClickActionType.starType
////        pickDataArr = WOWConstellation
//        
//        self.pickerContainerView.pickerView.reloadComponent(0)
//        if starRow == 0 {
//            pickerContainerView.pickerView.selectRow(starRow, inComponent: 0, animated: true)
//        }else {
//            pickerContainerView.pickerView.selectRow(starRow - 1, inComponent: 0, animated: true)
//        }
//        
////        self.pickerContainerView.pickerView.reloadComponent(0)
//        self.pickerContainerView.pickerView.reloadAllComponents()
//        showPickerView()
        
    }
    /**
     点击性别选择按钮
     
     */
    @IBAction func sexClick(_ sender: UIButton) {
        manButton.isSelected = (sender == manButton)
        womanButton.isSelected = (sender == womanButton)
        if sender.tag == 1001 { //男
            sex = 1
        }else{ //女
            sex = 2
        }
    }
}

//extension WOWRegistInfoSecondController:UITextFieldDelegate{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickDataArr.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        let currentType = clickType
//        switch currentType {
//            
//        case .ageType:
//            
//            return pickDataArr[row]
//        case .starType:
//            
//            return pickDataArr[row + 1]
//            
//            
//        }
//        
//    }
//    
//
//    /**
//     弹出选择器
//     */
//    fileprivate func showPickerView(){
//        
//        self.backGroundMaskView.isHidden = false
//        
//        UIView.animate(withDuration: 0.3){
//            self.pickerContainerView.mj_y = self.view.h - 250 + 64
//            
//        }
//    }
//    
//}

