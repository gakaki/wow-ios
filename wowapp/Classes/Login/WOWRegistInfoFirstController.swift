//
//  WOWRegistInfoFirstController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWRegistInfoFirstController: WOWBaseTableViewController {
    var fromUserCenter:Bool = false
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let nextView = NSBundle.mainBundle().loadNibNamed(String(WOWRegistInfoSureView), owner: self, options: nil).last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(nextButton), forControlEvents: .TouchUpInside)
        nextView.tipsLabel.hidden = true
        nextView.frame = CGRectMake(0,0, self.view.w, 200)
        tableView.tableFooterView = nextView
    }
    
    override func navBack() {
        let alert = UIAlertController(title: "您有资料未填写", message: "确定退出？", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
            DLog("取消")
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: {[weak self] (action) in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                if strongSelf.fromUserCenter{
                    UIApplication.appTabBarController.selectedIndex = 0
                }
            }
        }))
    }
    
//MARK:Actions
    func nextButton() {
        //FIXME:这个地方就该保存一部分信息了  更新用户信息，并且还得发送通知，更改信息咯
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistInfoSecondController)) as! WOWRegistInfoSecondController
        vc.fromUserCenter = fromUserCenter
        navigationController?.pushViewController(vc, animated: true)
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
    }

    
    
}


