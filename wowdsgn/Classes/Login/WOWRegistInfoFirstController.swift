
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
    var phoneNumber  :String?
    var headImageUrl:String = WOWUserManager.userHeadImageUrl
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
    
    func configTable(){
        nextView = Bundle.main.loadNibNamed(String(describing: WOWRegistInfoSureView.self), owner: self, options: nil)?.last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(nextButton), for: .touchUpInside)
        nextView.tipsLabel.isHidden = true
        nextView.frame = CGRect(x: 0,y: 0, width: self.view.w, height: 200)
        tableView.tableFooterView = nextView
    }
    
    override func navBack() {
        let alert = UIAlertController(title: "您有资料未填写", message: "确定退出？", preferredStyle: .alert)
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler: { (action) in
            DLog("取消")
        })

        let sure   = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
            if let strongSelf = self{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                  _ =  strongSelf.navigationController?.popViewController(animated: true)
                    if strongSelf.isPresent{
                        UIApplication.appTabBarController.selectedIndex = 0
                    }
                })

            }
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)

    }
    
//MARK:Actions
    func nextButton() {
        guard let nickName = nickTextField.text , !nickName.isEmpty else{
            WOWHud.showMsg("请输入昵称")
            nextView.tipsLabel.isHidden = false
            nextView.tipsLabel.textColor = UIColor.red
            nextView.tipsLabel.text = "请输入昵称"
            return
        }
        let params = ["nickName":nickTextField.text!,"selfIntroduction":descTextField.text ?? "","avatar":self.headImageUrl]
        WOWNetManager.sharedManager.requestWithTarget(.api_Change(param:params), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                DLog(result)
                //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
                WOWUserManager.userName = strongSelf.nickTextField.text!
//                WOWUserManager.userHeadImageUrl = strongSelf.userInfoFromWechat.icon
                WOWUserManager.userDes = strongSelf.descTextField.text ?? ""
                
                let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWRegistInfoSecondController.self)) as! WOWRegistInfoSecondController
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0: //头像
            showPicture()
        default:
            break;
        }
    }
    
    func showPicture(){
        let actionSheetController: UIAlertController = UIAlertController(title: "更改头像", message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "相机拍照", style: .default) { action -> Void in
            self.choosePhtot(.camera)
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "相册选取", style: .default) { action -> Void in
            self.choosePhtot(.photoLibrary)
        }
        actionSheetController.addAction(choosePictureAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func choosePhtot(_ type:UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(type){
            //指定图片控制器类型
            imagePicker.sourceType = type
            //弹出控制器，显示界面
            self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(imagePicker, animated: true, completion:nil)
        }else{
            DLog("读取相册错误")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
        
        WOWUploadManager.upload(image, successClosure: { [weak self](result) in
            WOWHud.dismiss()
            self!.headImageView.image = image

            self!.headImageUrl = (result as? String) ?? ""

            
            print(result)
            
        }) { (errorMsg) in
            
            print(errorMsg)
        }
        
    }
    
}
//MARK:Delegate

extension WOWRegistInfoFirstController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

