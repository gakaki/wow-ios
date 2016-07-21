//
//  WOWRegistInfoSecondController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit


class WOWRegistInfoSecondController: WOWBaseTableViewController {
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    var editingTextField:UITextField?
    var fromUserCenter:Bool = false
    var sex = 1
    var ageRow = Int(3)
    var starRow = Int()
    
    var pickDataArr:[Int:String] = [Int:String]()
    lazy var pickerContainerView :WOWPickerView = {
        let v = NSBundle.mainBundle().loadNibNamed("WOWPickerView", owner: self, options: nil).last as! WOWPickerView
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        sex = WOWUserManager.userSex
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        configTable()
        configNav()
        configTextField()
    }
    
    private func configTextField(){
        ageTextField.inputView = pickerContainerView
        starTextField.inputView = pickerContainerView
        pickerContainerView.pickerView.delegate = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancelPicker), forControlEvents:.TouchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(surePicker), forControlEvents:.TouchUpInside)

    }
    
    private func configNav(){
        makeCustomerNavigationItem("跳过", left: false) {[weak self] in
            if let strongSelf = self{
               
//                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                if strongSelf.fromUserCenter{
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                    print("gerenzhongxin")
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
    }
    
    func surePicker() {
        let row = pickerContainerView.pickerView.selectedRowInComponent(0)
        
        if editingTextField == ageTextField {
            ageRow = row
            editingTextField?.text = pickDataArr[row]
        }else{
            starRow = row + 1
            editingTextField?.text = pickDataArr[row + 1]
        }
        cancelPicker()
    }
    
    
    func sure() {
        let params = ["sex":String(sex),"ageRange":String(ageRow),"constellation":String(starRow),"industry":jobTextField.text ?? ""]
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params ), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                DLog(result)
                print(result)
                //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
                WOWUserManager.userSex = strongSelf.sex
                WOWUserManager.userConstellation = strongSelf.starRow
                WOWUserManager.userAgeRange = strongSelf.ageRow
                WOWUserManager.userIndustry = strongSelf.jobTextField.text ?? ""
                
                strongSelf.toLoginSuccess(strongSelf.fromUserCenter)
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }

    }
    
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
        
        if editingTextField == ageTextField {
            return pickDataArr[row]
        }else{
            return pickDataArr[row + 1]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if editingTextField == ageTextField {
            editingTextField?.text = pickDataArr[row]
        }else{
            editingTextField?.text = pickDataArr[row + 1]
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        editingTextField = textField
        if editingTextField == ageTextField {
            pickDataArr = WOWAgeRange
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(ageRow, inComponent: 0, animated: true)
        }else if editingTextField == starTextField{
            pickDataArr = WOWConstellation
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(starRow, inComponent: 0, animated: true)
        }

        return true
    }

}

