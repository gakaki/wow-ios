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
    var sex = "男"
    var pickDataArr:[String] = [String]()
    lazy var pickerContainerView :WOWPickerView = {
        let v = NSBundle.mainBundle().loadNibNamed("WOWPickerView", owner: self, options: nil).last as! WOWPickerView
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
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
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                if strongSelf.fromUserCenter{
                    UIApplication.appTabBarController.selectedIndex = 0
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
        editingTextField?.text = pickDataArr[row]
        cancelPicker()
    }
    
    
    func sure() {
        dismissViewControllerAnimated(true, completion: nil)
        if fromUserCenter{
            UIApplication.appTabBarController.selectedIndex = 0
        }
    }
    
    @IBAction func sexClick(sender: UIButton) {
        manButton.selected = (sender == manButton)
        womanButton.selected = (sender == womanButton)
        if sender.tag == 1001 { //男
            sex = "男"
        }else{ //女
            sex = "女"
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
        return pickDataArr[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editingTextField?.text = pickDataArr[row]
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        editingTextField = textField
        if textField == ageTextField {
            pickDataArr = ["00后","95后","90后","85后","80后","75后","70后","65后","60后"]
        }else if textField == starTextField{
            pickDataArr = ["水瓶座","双鱼座","白羊座","金牛座","双子座","巨蟹座","狮子座","处女座","天秤座","天蝎座","射手座","摩羯座"]
        }
        self.pickerContainerView.pickerView.reloadComponent(0)
        let row = pickDataArr.indexesOf(textField.text ?? "").first ?? 0
        pickerContainerView.pickerView.selectRow(row, inComponent: 0, animated: true)
        return true
    }

}

