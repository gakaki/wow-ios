//
//  WOWReleaseWorksController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWReleaseWorksController: WOWBaseViewController {
    var photo : UIImage!

    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    var instagramCategoryId:Int?
    var imgSizeId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        self.imgPhoto.image = photo
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = true
        let itemReghit = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = itemReghit

        // Do any additional setup after loading the view.
    }
    func cancelAction()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func requestPushWorks(pic:String ,des:String){
        
        var params = [String: Any]()
         params = ["instagramCategoryId": instagramCategoryId ?? 0  ,"pic": pic ,"description":des]
        if let imgSizeId = imgSizeId {
            if imgSizeId > 0 {
                params["measurement"] = imgSizeId
            }
        }
        
       

        WOWNetManager.sharedManager.requestWithTarget(.api_PushWorks(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                strongSelf.toWorksDetails(worksId:7)
            
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
             
                WOWHud.dismiss()
                
            }
        }

    }

    // MARK: - 发布按钮
    @IBAction func releaseAction(_ sender: Any) {
        
        toWorksDetails(worksId:7)
        
//        WOWHud.showLoadingSV()
//        WOWUploadManager.uploadShareImg(photo, successClosure: {[weak self] (url) in
//           
//            if let strongSelf = self {
//                strongSelf.requestPushWorks(pic: url ?? "", des: "hahaha")
//            }
//            
//            
//        }) { (error) in
//            WOWHud.dismiss()
//            print("upload error...")
//        }

    }
    // MARK: - 跳转到作品详情
    func toWorksDetails(worksId:Int) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWWorksDetailsController.self)) as! WOWWorksDetailsController
        
        vc.photo = photo
        vc.worksId = worksId
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
