//
//  WOWUserInfoController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit


class WOWUserInfoController: WOWBaseTableViewController {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var nickLabel: UILabel!
    //个性签名
    @IBOutlet weak var desLabel: UILabel!
    
    var editInfoAction:WOWActionClosure?
    
    private var headImageUrl:String = WOWUserManager.userHeadImageUrl
    private var nick        :String = WOWUserManager.userName
    private var sex         :String = WOWSex[WOWUserManager.userSex]!
    private var des         :String = WOWUserManager.userDes
//    private var star        :string = WOWUserManager.userStar
    
    var pickDataArr:[String] = [String]()
    var editingTextField:UITextField?
//MARK:Lazy
    lazy var imagePicker:UIImagePickerController = {
        let v = UIImagePickerController()
        v.delegate = self
        return v
    }()
    
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
        navigationItem.title = "个人信息"
        headImageView.borderRadius(25)
        configUserInfo()
        configTextField()
    }
    
    private func configTextField(){
        ageTextField.inputView = pickerContainerView
        sexTextField.inputView = pickerContainerView
        starTextField.inputView = pickerContainerView
        pickerContainerView.pickerView.delegate = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancelPicker), forControlEvents:.TouchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(surePicker), forControlEvents:.TouchUpInside)
    }
    
    private func configUserInfo(){
        dispatch_async(dispatch_get_main_queue()) {
            self.sexTextField.text  = WOWAgeRange[WOWUserManager.userSex]!
            self.desLabel.text      = WOWUserManager.userDes
            self.nickLabel.text     = WOWUserManager.userName
            self.headImageView.kf_setImageWithURL(NSURL(string:WOWUserManager.userHeadImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_userhead"))
        }
    }
    
//MARK:Actions
    func cancelPicker(){
        ageTextField.resignFirstResponder()
        starTextField.resignFirstResponder()
        sexTextField.resignFirstResponder()
    }
    
    func surePicker() {
        let row = pickerContainerView.pickerView.selectedRowInComponent(0)
        editingTextField?.text = pickDataArr[row]
        cancelPicker()
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        let params = ["headimage":headImageUrl,"nick":nick,"desc":des,"sex":sex,"uid":WOWUserManager.userID]
        WOWNetManager.sharedManager.requestWithTarget(.Api_UserUpdate(param:params), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                let model = Mapper<WOWUserModel>().map(result["user"])
                WOWUserManager.saveUserInfo(model)
                strongSelf.configUserInfo()
                WOWHud.dismiss()
                if let action = strongSelf.editInfoAction{
                    action()
                }
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
            DLog(errorMsg)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destina = segue.destinationViewController as? WOWInfoTextController
        guard let toVC = destina else{
            return
        }
        let segueid = segue.identifier
        switch segueid!{
        case "usernick":
            toVC.entrance = InfoTextEntrance.NickEntrance(value: "昵称")
        case "userdesc":
            toVC.entrance = InfoTextEntrance.NickEntrance(value: "签名")
        case "userjob":
            toVC.entrance = InfoTextEntrance.NickEntrance(value: "职业")
        default:break
        }
    }
}


extension WOWUserInfoController{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            showPicture()
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 15
    }
    
    private func showPicture(){
        let actionSheetController: UIAlertController = UIAlertController(title: "更改头像", message: nil, preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            
        }
         actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "相机拍照", style: .Default) { action -> Void in
            self.choosePhtot(.Camera)
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "相册选取", style: .Default) { action -> Void in
            self.choosePhtot(.PhotoLibrary)
        }
        actionSheetController.addAction(choosePictureAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    private func choosePhtot(type:UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(type){
            //指定图片控制器类型
            imagePicker.sourceType = type
            //弹出控制器，显示界面
            self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.presentViewController(imagePicker, animated: true, completion:nil)
        }else{
            DLog("读取相册错误")
        }
    }
}




//MARK:Delegate

extension WOWUserInfoController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let data = UIImageJPEGRepresentation(image,0.5)
        let file = AVFile(name:"headimage.jpg", data:data)
        WOWHud.showLoading()
        file.saveInBackgroundWithBlock {[weak self] (ret,error) in
            if let strongSelf = self{
                if let e = error{
                    DLog(e)
                    WOWHud.showMsg("头像修改失败")
                    return
                }else{
                    strongSelf.headImageUrl = file.url
                    strongSelf.request()
                }
            }
        }
    }
    
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
    
   func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        editingTextField = textField
        if textField == ageTextField {
            pickDataArr = ["00后","95后","90后","85后","80后","75后","70后","65后","60后"]
        }else if textField == starTextField{
            pickDataArr = ["水瓶座","双鱼座","白羊座","金牛座","双子座","巨蟹座","狮子座","处女座","天秤座","天蝎座","射手座","摩羯座"]
        }else if textField == sexTextField{
            pickDataArr = ["男","女"]
        }
        self.pickerContainerView.pickerView.reloadComponent(0)
        let row = pickDataArr.indexesOf(textField.text ?? "").first ?? 0
        pickerContainerView.pickerView.selectRow(row, inComponent: 0, animated: true)
        return true
    }
    
}




