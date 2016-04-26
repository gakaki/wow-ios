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
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    //个性签名
    @IBOutlet weak var desLabel: UILabel!
    
    var editInfoAction:ActionClosure?
    
    private var headImageUrl:String = WOWUserManager.userHeadImageUrl
    private var nick        :String = WOWUserManager.userName
    private var sex         :String = WOWUserManager.userSex
    private var des         :String = WOWUserManager.userDes
    
//MARK:Lazy
    lazy var imagePicker:UIImagePickerController = {
        let v = UIImagePickerController()
        v.delegate = self
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "个人信息"
        headImageView.borderRadius(23)
        headImageView.kf_setImageWithURL(NSURL(string:WOWUserManager.userHeadImageUrl)!, placeholderImage:UIImage(named: "placeholder_userhead"))
        configUserInfo()
    }
    
    private func configUserInfo(){
        dispatch_async(dispatch_get_main_queue()) { 
            self.sexLabel.text    = WOWUserManager.userSex
            self.desLabel.text    = WOWUserManager.userDes
            self.nickLabel.text   = WOWUserManager.userName
            self.headImageView.kf_setImageWithURL(NSURL(string:WOWUserManager.userHeadImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_userhead"))
        }
    }
    
//MARK:Actions
    func editInfoComplete() {
        if let closure = self.editInfoAction {
            closure()
        }
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        let params = ["user_headimage":headImageUrl,"user_nick":nick,"user_desc":des,"user_sex":sex,"uid":WOWUserManager.userID]
        WOWNetManager.sharedManager.requestWithTarget(.Api_UserUpdate(param:params), successClosure: { [weak self](result) in
            if let strongSelf = self{
                DLog(result)
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
}


extension WOWUserInfoController{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            DLog("头像")
            showPicture()
        case 1:
            changeNick()
        case 2:
            changeDes()
        case 3:
            changeSex()
        default:
            break
        }
    }
    
    //更改签名
    private func changeDes(){
        let alertController: UIAlertController = UIAlertController(title: "更改签名", message: nil, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            
        }
        
        alertController.addAction(cancelAction)
        let sureAction: UIAlertAction = UIAlertAction(title: "确定", style: .Default) { action -> Void in
            let field = alertController.textFields?.first
            self.des = field?.text ?? ""
            self.request()
        }
        alertController.addAction(sureAction)
        alertController.addTextFieldWithConfigurationHandler { (field) in
            field.placeholder = "请输入签名"
        }
        self.presentViewController(alertController, animated: true, completion: nil)

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
    
    
    //更改昵称
    private func changeNick(){
        let alertController: UIAlertController = UIAlertController(title: "更改昵称", message: nil, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            
        }
        
        alertController.addAction(cancelAction)
        let sureAction: UIAlertAction = UIAlertAction(title: "确定", style: .Default) { action -> Void in
            let field = alertController.textFields?.first
            self.nick = field?.text ?? ""
            self.request()
        }
        alertController.addAction(sureAction)
        alertController.addTextFieldWithConfigurationHandler { (field) in
            field.placeholder = "请输入昵称"
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func changeSex(){
        let actionSheetController: UIAlertController = UIAlertController(title: "更改性别", message: nil, preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        let manAction: UIAlertAction = UIAlertAction(title: "男", style: .Default) { action -> Void in
            self.sex = "男"
            self.request()
        }
        actionSheetController.addAction(manAction)
        let womanAction: UIAlertAction = UIAlertAction(title: "女", style: .Default) { action -> Void in
            self.sex = "女"
            self.request()
        }
        actionSheetController.addAction(womanAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}





//MARK:Delegate

extension WOWUserInfoController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)        
        let data = UIImageJPEGRepresentation(image,0.8)
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

                    /*
                    let wowUser = AVQuery(className:"WOWUser")
                    wowUser.whereKey("wowuserid", equalTo:WOWUserManager.userID)
                    wowUser.findObjectsInBackgroundWithBlock({[weak self] (objects, error) in
                        if let _ = self{
                            if let e = error{
                                DLog(e)
                                WOWHud.showMsg("头像修改失败")
                                return
                            }
                            if let object = objects.last as? AVObject{
                                object.setObject(headUrl, forKey:"wowheadimageurl")
                                object.saveInBackgroundWithBlock({[weak self](ret,error) in
                                    if let strongSelf = self{
                                        if let e = error{
                                            DLog(e)
                                            WOWHud.showMsg("头像修改失败")
                                            return
                                        }else{
                                            WOWHud.showMsg("头像修改成功")
                                            WOWUserManager.userHeadImageUrl = headUrl
                                            strongSelf.editInfoComplete()
                                        }
                                    }
                                })
                            }
                        }
                    })
                     */
                }
            }
        }
    }
}




