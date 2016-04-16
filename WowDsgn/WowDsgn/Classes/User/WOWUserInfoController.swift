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
            self.desLabel.text = field?.text
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
            
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "相册选取", style: .Default) { action -> Void in
            
            }
        actionSheetController.addAction(choosePictureAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    private func changeNick(){
        let alertController: UIAlertController = UIAlertController(title: "更改昵称", message: nil, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            
        }
        
        alertController.addAction(cancelAction)
        let sureAction: UIAlertAction = UIAlertAction(title: "确定", style: .Default) { action -> Void in
            let field = alertController.textFields?.first
            self.nickLabel.text = field?.text
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
            self.sexLabel.text = "男"
        }
        actionSheetController.addAction(manAction)
        let womanAction: UIAlertAction = UIAlertAction(title: "女", style: .Default) { action -> Void in
            self.sexLabel.text = "女"
        }
        actionSheetController.addAction(womanAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }

    
}