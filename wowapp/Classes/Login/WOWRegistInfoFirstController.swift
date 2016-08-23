
//
//  WOWRegistInfoFirstController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import Qiniu
import Alamofire
import Hashids_Swift
import FCUUID
class WOWRegistInfoFirstController: WOWBaseTableViewController {
    var isPresent:Bool = false
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    private var headImageUrl:String = WOWUserManager.userHeadImageUrl
    var nextView : WOWRegistInfoSureView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.telTextField.text = WOWUserManager.userMobile
        self.nickTextField.text = WOWUserManager.userName
//        headImageView.kf_setImageWithURL(NSURL(string:WOWUserManager.userHeadImageUrl)!, placeholderImage: UIImage(named: "placeholder_userhead"))
        headImageView.borderRadius(25)
        headImageView.set_webimage_url_user( WOWUserManager.userHeadImageUrl )

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK:Lazy
    lazy var imagePicker:UIImagePickerController = {
        let v = UIImagePickerController()
        v.delegate = self
        return v
    }()
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
    }
    
    private func configTable(){
        nextView = NSBundle.mainBundle().loadNibNamed(String(WOWRegistInfoSureView), owner: self, options: nil).last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(nextButton), forControlEvents: .TouchUpInside)
        nextView.tipsLabel.hidden = true
        nextView.frame = CGRectMake(0,0, self.view.w, 200)
        tableView.tableFooterView = nextView
    }
    
    override func navBack() {
        let alert = UIAlertController(title: "您有资料未填写", message: "确定退出？", preferredStyle: .Alert)
        let cancel = UIAlertAction(title:"取消", style: .Cancel, handler: { (action) in
            DLog("取消")
        })

        let sure   = UIAlertAction(title: "确定", style: .Default) {[weak self] (action) in
            if let strongSelf = self{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    strongSelf.navigationController?.popViewControllerAnimated(true)
                    if strongSelf.isPresent{
                        UIApplication.appTabBarController.selectedIndex = 0
                    }
                })

            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)

    }
    
//MARK:Actions
    func nextButton() {
        guard let nickName = nickTextField.text where !nickName.isEmpty else{
            WOWHud.showMsg("请输入昵称")
            nextView.tipsLabel.hidden = false
            nextView.tipsLabel.textColor = .redColor()
            nextView.tipsLabel.text = "请输入昵称"
            return
        }
        let params = ["nickName":nickTextField.text!,"selfIntroduction":descTextField.text ?? "","avatar":self.headImageUrl]
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                DLog(result)
                //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
                WOWUserManager.userName = strongSelf.nickTextField.text!
//                WOWUserManager.userHeadImageUrl = strongSelf.userInfoFromWechat.icon
                WOWUserManager.userDes = strongSelf.descTextField.text ?? ""
                
                let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistInfoSecondController)) as! WOWRegistInfoSecondController
                vc.isPresent = strongSelf.isPresent
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{

            }
        }
        
        
    }
}


extension WOWRegistInfoFirstController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: //头像
            showPicture()
        default:
            break;
        }
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
//        let data = UIImageJPEGRepresentation(image,0.5)
        headImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let data = UIImageJPEGRepresentation(image,0.5)
        WOWHud.showLoading()
        
        
        let uploadOption            = QNUploadOption.init(
            mime: nil,
            progressHandler: { ( key, percent_f) in
                //                print(key,percent_f)
            },
            params: nil  ,
            checkCrc: false,
            cancellationSignal: nil
        )
        
        
        let hashids                 = Hashids(salt:FCUUID.uuidForDevice())
        let mobile                  = WOWUserManager.userMobile;
        let qiniu_key               = "user/avatar/\(hashids.encode([1,2,3])!)"
        //        let qiniu_key               = "user/avatar/13621822254"
        let qiniu_token_url         = "\(BaseUrl)qiniutoken"
        
        let json_str                = json_serialize( ["key": qiniu_key,"bucket": "wowdsgn"] )
        let params_qiniu            = ["paramJson": json_str ]
        
        
        Alamofire.request(.POST,qiniu_token_url, parameters: params_qiniu)
            .response { request, response, data, error in
                DLog(request)
                DLog(response)
                DLog(data)
                DLog(error)
                
                self.headImageView.image =  image
                
                if (( error ) != nil){
                    WOWHud.dismiss()
                }
                
                
            }.responseJSON { (json) in
                
                let res   = JSON(json.result.value!)
                let token = res["data"]["token"].string
                
                let qm    = QNUploadManager()
                
                qm.putData(
                    data,
                    key:   qiniu_key,
                    token: token,
                    complete: { ( info, key, resp) in
                        
                        WOWHud.dismiss()
                        
                        if (info.error != nil) {
                            DLog(info.error)
                            WOWHud.showMsg("头像修改失败")
                        } else {
                            
                            print(resp,resp["key"])
                            print(info,key,resp)
                            let key = resp["key"]
                            self.headImageUrl = "http://img.wowdsgn.com/\(key!)"
                            DLog(self.headImageUrl)
                            
                            
                            WOWUserManager.userHeadImageUrl = self.headImageUrl
//                            self.image               =  image
                            let imageData:NSData = NSKeyedArchiver.archivedDataWithRootObject(image)
                            //                        let userDefault = NSUserDefaults.standardUserDefaults()
                            //                        userDefault.setObject(imageData, forKey: "imageData")
                            WOWUserManager.userPhotoData = imageData
//                            NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateUserHeaderImageNotificationKey, object: nil ,userInfo:["image":image])
                            
//                            self.request()
                        }
                        
                        
                    },
                    option: uploadOption
                )
                
        }

    }

    
    
}
//MARK:Delegate

extension WOWRegistInfoFirstController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

