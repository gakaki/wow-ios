//
//  WOWUserInfoController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import PromiseKit
import Qiniu
import QiniuTokenIOS
import Hashids_Swift
import AwaitKit

class WOWUserInfoController: WOWBaseTableViewController {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    //个性签名
    @IBOutlet weak var desLabel: UILabel!
    
    
    var editInfoAction:WOWActionClosure?
    
    private var headImageUrl:String = WOWUserManager.userHeadImageUrl
    private var nick        :String = WOWUserManager.userName
    private var sex         :Int = WOWUserManager.userSex
    private var des         :String = WOWUserManager.userDes
    private var star        :Int = WOWUserManager.userConstellation
    private var age         :Int = WOWUserManager.userAgeRange
    
    var pickDataArr:[Int:String] = [Int:String]()
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            configUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "个人信息"
        headImageView.borderRadius(25)
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
            self.sexTextField.text  = WOWSex[WOWUserManager.userSex]!
            self.desLabel.text      = WOWUserManager.userDes
            self.nickLabel.text     = WOWUserManager.userName
            self.ageTextField.text  = WOWAgeRange[self.age]!
            self.starTextField.text = WOWConstellation[self.star]
            self.jobLabel.text      = WOWUserManager.userIndustry
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
        
        if editingTextField == ageTextField {
            age = row
            editingTextField?.text = pickDataArr[row]
        }else if editingTextField == starTextField {
            star = row + 1
            editingTextField?.text = pickDataArr[row + 1]
        }else if editingTextField == sexTextField {
            sex = row + 1
        }

        cancelPicker()
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        let params = ["headimage":headImageUrl,"sex":String(sex),"ageRange":String(age),"constellation":String(star)]
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
//                let model = Mapper<WOWUserModel>().map(result["user"])
//                WOWUserManager.saveUserInfo(model)
                //保存一些用户信息
                WOWUserManager.userHeadImageUrl = strongSelf.headImageUrl
                WOWUserManager.userSex = strongSelf.sex
                WOWUserManager.userAgeRange = strongSelf.age
                WOWUserManager.userConstellation = strongSelf.star
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
            toVC.userInfo = WOWUserManager.userName
        case "userdesc":
            toVC.entrance = InfoTextEntrance.DescEntrance(value: "签名")
            toVC.userInfo = WOWUserManager.userDes
        case "userjob":
            toVC.entrance = InfoTextEntrance.JobEntrance(value: "职业")
            toVC.userInfo = WOWUserManager.userIndustry
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
                    
                    let qiniu_path          = try! await( strongSelf.upload_to_swift(file.url) )
                    strongSelf.headImageUrl = qiniu_path
                    print(qiniu_path)
                    
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
        if editingTextField == ageTextField {
            return pickDataArr[row]
        }else {
            return pickDataArr[row + 1]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
//        if editingTextField == ageTextField {
//            age = row
//            editingTextField?.text = pickDataArr[row]
//        }else if editingTextField == starTextField{
//            star = row + 1
//            editingTextField?.text = pickDataArr[row + 1]
//        }else if editingTextField == sexTextField {
//            sex = row + 1
//            editingTextField?.text = pickDataArr[row + 1]
//        }
    }
    
   func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        editingTextField = textField
        if textField == ageTextField {
            pickDataArr = WOWAgeRange
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(age, inComponent: 0, animated: true)
        }else if textField == starTextField{
            pickDataArr = WOWConstellation
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(star - 1, inComponent: 0, animated: true)
        }else if textField == sexTextField{
            pickDataArr = WOWSex
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(sex - 1, inComponent: 0, animated: true)
        }
        return true
    }
    
}

extension WOWUserInfoController{
    
    
    func upload_to_swift( file_path: String ) -> Promise<String> {
        
        return Promise { resolve, reject in
            
            let qiniu_upload_manager = GCQiniuUploadManager.sharedInstance()
            
            qiniu_upload_manager.registerWithScope(
                "wowdsgn",
                accessKey: "l4bcP6bByVSJWgqOeKxHGtCyXl3L3bWlLh9wOLYu",
                secretKey: "kevimwWUrbsidQLFRD00zadC0RSUt7qZOFHUW7OY"
            )
            qiniu_upload_manager.createToken()
            
            print ("Token is \(qiniu_upload_manager.uploadToken)")
            
            let uploadOption            = QNUploadOption.init(
                mime: nil,
                progressHandler: { ( key, percent_f) in
                    print(key,percent_f)
                },
                params: nil  ,
                checkCrc: false,
                cancellationSignal: nil
            )
            
            let hashids                 = Hashids(salt:"this is my salt")
            let qiniu_key               =  "user/avatar/\(hashids.encode([1,2,3])!)"
            let qm                      = QNUploadManager()
            qm.putFile(
                file_path,
                key: qiniu_key,
                token: qiniu_upload_manager.uploadToken,
                complete: { ( info, key, resp) in
                    print(info,key,resp)
                    resolve(key)
                },
                option: uploadOption
            )
        }
    }
    
    func upload_to_swift2( file_path: String ) -> Promise<String> {
        return Promise { resolve, reject in
            let qiniu_url = "2"
            resolve(qiniu_url)
        }
    }
    
    
    
}


