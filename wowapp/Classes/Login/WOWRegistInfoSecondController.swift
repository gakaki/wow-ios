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
    var  backGroundMaskView : UIView! // 背景蒙板
    var  backGroundWindow : UIWindow!
    var clickType = ClickActionType.ageType
    var isPresent:Bool = false
    var sex = 1
    var ageRow = Int(0)
    var starRow = Int(0)
    
    var pickDataArr:[Int:String] = [Int:String]()
    lazy var pickerContainerView :WOWPickerView = {
        let v = NSBundle.mainBundle().loadNibNamed("WOWPickerView", owner: self, options: nil).last as! WOWPickerView
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        sex = WOWUserManager.userSex
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configPickerView()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        backGroundMaskView.removeFromSuperview()
        pickerContainerView.removeFromSuperview()
        
        
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
    
    private func configPickerView(){
        
        backGroundMaskView = UIView()
        backGroundMaskView.frame = CGRectMake(0, 0 , MGScreenWidth, MGScreenHeight)
        backGroundMaskView.backgroundColor = UIColor.blackColor()
        backGroundMaskView.alpha = 0.2
        
        
        
        backGroundMaskView.addTapGesture(target: self, action: #selector(cancelPicker))
        
        pickerContainerView.frame = CGRectMake(0, MGScreenHeight,UIApplication.currentViewController()?.view.w ?? MGScreenWidth, 250)
        
        
        pickerContainerView.pickerView.delegate = self
        
        pickerContainerView.cancelButton.hidden = false
        pickerContainerView.sureButton.addTarget(self, action:#selector(surePicker), forControlEvents:.TouchUpInside)
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        
        //        pickerContainerView.tag == 1001
        
        backGroundWindow = UIApplication.sharedApplication().keyWindow
        
        backGroundWindow.addSubview(backGroundMaskView)
        backGroundWindow.addSubview(pickerContainerView)
        backGroundMaskView.hidden = true
        
        
    }
    
    private func configNav(){
        makeCustomerNavigationItem("跳过", left: false) {[weak self] in
            if let strongSelf = self{
                
                
                if strongSelf.isPresent{
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                    UIApplication.appTabBarController.selectedIndex = 0
                }else {
                    //进入首页
                    strongSelf.toMainVC()
                }
            }
        }
    }
    
    private func configTable(){
        let nextView = NSBundle.mainBundle().loadNibNamed(String(WOWRegistInfoSureView), owner: self, options: nil).last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(sure), forControlEvents: .TouchUpInside)
        nextView.sureButton.setTitle("完成", forState: .Normal)
        nextView.frame = CGRectMake(0,0, self.view.w, 200)
        tableView.tableFooterView = nextView
    }
    
    
    //MARK:Actions
    func cancelPicker(){
        ageTextField.resignFirstResponder()
        starTextField.resignFirstResponder()
        
        self.backGroundMaskView.hidden = true
        UIView.animateWithDuration(0.3){
            self.pickerContainerView.mj_y = MGScreenHeight
        }
        
    }
    
    func surePicker() {
        let row = pickerContainerView.pickerView.selectedRowInComponent(0)
        
        let currentType = clickType
        switch currentType {// 星座下标从1开始，所以，做＋1处理 ，性别从1开始，默认为1，年龄从0开始
            
        case .ageType:
            ageRow = row
            ageTextField?.text = pickDataArr[row]
        case .starType:
            starRow = row + 1
            starTextField?.text = pickDataArr[row + 1]
            
        }
        
        cancelPicker()
    }
    
    
    func cancel() {
        self.backGroundMaskView.hidden = true
        UIView.animateWithDuration(0.3){
            self.pickerContainerView.mj_y = MGScreenHeight
        }

    }

    func sure() {
//        print("\(sex)","\(ageRow)","\(starRow)")
        let params = ["sex":String(sex),"ageRange":String(ageRow),"constellation":String(starRow),"industry":jobTextField.text ?? ""]
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params ), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                DLog(result)
                //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
                WOWUserManager.userSex = strongSelf.sex
                WOWUserManager.userConstellation = strongSelf.starRow
                WOWUserManager.userAgeRange = strongSelf.ageRow
                WOWUserManager.userIndustry = strongSelf.jobTextField.text ?? ""
                
                strongSelf.toLoginSuccess(strongSelf.isPresent)
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }
        
    }
    /**
     点击年龄选择按钮
     
     */
    @IBAction func ageClick(sender: UIButton){
        clickType = ClickActionType.ageType
        pickDataArr = WOWAgeRange
        
        self.pickerContainerView.pickerView.reloadComponent(0)
        pickerContainerView.pickerView.selectRow(ageRow, inComponent: 0, animated: true)
        self.pickerContainerView.pickerView.reloadComponent(0)
        showPickerView()
        jobTextField.resignFirstResponder()
    }
    /**
     点击星座选择按钮
     
     */
    @IBAction func starClick(sender: UIButton){
        clickType = ClickActionType.starType
        pickDataArr = WOWConstellation
        
        self.pickerContainerView.pickerView.reloadComponent(0)
        pickerContainerView.pickerView.selectRow(starRow - 1, inComponent: 0, animated: true)
//        self.pickerContainerView.pickerView.reloadComponent(0)
        self.pickerContainerView.pickerView.reloadAllComponents()
        showPickerView()
        jobTextField.resignFirstResponder()
        
    }
    /**
     点击性别选择按钮
     
     */
    @IBAction func sexClick(sender: UIButton) {
        manButton.selected = (sender == manButton)
        womanButton.selected = (sender == womanButton)
        if sender.tag == 1001 { //男
            sex = 1
        }else{ //女
            sex = 2
        }
    }
}

extension WOWRegistInfoSecondController:UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickDataArr.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let currentType = clickType
        switch currentType {
            
        case .ageType:
            
            return pickDataArr[row]
        case .starType:
            
            return pickDataArr[row + 1]
            
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        let currentType = clickType
//        switch currentType {
//            
//        case .ageType:
//            ageRow = row
//            ageTextField?.text = pickDataArr[row]
//        case .starType:
//            starRow = row + 1
//            starTextField?.text = pickDataArr[row + 1]
//            
//            
//        }
    }
    /**
     弹出选择器
     */
    private func showPickerView(){
        
        self.backGroundMaskView.hidden = false
        
        UIView.animateWithDuration(0.3){
            self.pickerContainerView.mj_y = self.view.h - 250 + 64
            
        }
    }
    
}

