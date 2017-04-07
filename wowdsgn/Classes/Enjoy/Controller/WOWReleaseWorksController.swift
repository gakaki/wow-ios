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

    @IBOutlet weak var imgHeightLayou: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    var modelData : WOWWorksDetailsModel?
    var instagramCategoryId:Int?

    var imgSizeId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        self.imgPhoto.image = photo

        textView.delegate = self
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = true
        let itemReghit = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = itemReghit

        let tapGestureRecognizer = UIPanGestureRecognizer.init(target: self, action:  #selector(tap))
    
        self.view.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.e(.post_picture_page)
    }
    
    func tap(gestureRecognizer: UIPanGestureRecognizer)  {
     self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.imgPhoto.mj_w  * photo.size.height / photo.size.width
        imgHeightLayou.constant = height
    }
    func cancelAction()  {
        
        let alertController = UIAlertController(title: "",
                                                message: "退出此次编辑？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "退出", style: .default, handler: {
            action in
            
            self.dismiss(animated: true) {
                MobClick.e(.cancel_post_picture_page)
                _ = FNUtil.currentTopViewController().navigationController?.popViewController(animated: true)
            }
  
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
      
    }
    
    func requestPushWorks(pic:String ,des:String){
        
        var params = [String: Any]()
        params = ["instagramCategoryId": instagramCategoryId ?? 0  ,"pic": pic ,"description":des , "measurement":imgSizeId  ?? 1]

        WOWNetManager.sharedManager.requestWithTarget(.api_PushWorks(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                let r = JSON(result)
                print(r)
                
                strongSelf.modelData    =    Mapper<WOWWorksDetailsModel>().map(JSONObject:result)
                
                strongSelf.toWorksDetails(worksId:strongSelf.modelData?.id ?? 0)
            
                
            }
        }) {[weak self] (errorMsg) in
            if self != nil{
             
                WOWHud.showMsgNoNetWrok(message: errorMsg)
                
            }
        }

    }
    // MARK: - 发布按钮
    @IBAction func releaseAction(_ sender: Any) {
            MobClick.e(.post_clicks_post_picture_page)
            requestPushlish()
        
    }
    func requestPushlish()  {
        let des = textView.text ?? ""
        if des.length > 35 {
            WOWHud.showMsg("请输入35字以内")
            return
        }
        textView.resignFirstResponder()
        
        WOWHud.showLoadingSV()
        WOWUploadManager.uploadShareImg(photo, successClosure: {[weak self] (url) in
            
            if let strongSelf = self {
                strongSelf.requestPushWorks(pic: url ?? "", des: des)
            }
            
            
        }) { (error) in
            WOWHud.dismiss()
            print("upload error...")
        }

    }
    // MARK: - 跳转到作品详情
    func toWorksDetails(worksId:Int) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWWorksDetailsController.self)) as! WOWWorksDetailsController
        vc.isBoolFormReleaseVC = true
        vc.photo = photo
        vc.worksId = worksId
        self.navigationController?.pushViewController(vc, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension WOWReleaseWorksController:UITextViewDelegate{
    
    fileprivate func limitTextLength(_ textView: UITextView){
        
        let toBeString = textView.text as NSString

        if (toBeString.length > 35) {
            numberLabel.colorWithText(toBeString.length.toString, str2: "/35", str1Color: UIColor.red)
            
        }else {
            numberLabel.text = String(format: "%i/35", toBeString.length)
        }

    }
    //中文和其他字符的判断方式不一样
    func textViewDidChange(_ textView: UITextView) {
        
        let language = textView.textInputMode?.primaryLanguage
   
        if let lang = language {
            if lang == "zh-Hans" ||  lang == "zh-Hant" || lang == "ja-JP"{ //如果是中文简体,或者繁体输入,或者是日文这种带默认带高亮的输入法
                let selectedRange = textView.markedTextRange
                var position : UITextPosition?
                if let range = selectedRange {
                    position = textView.position(from: range.start, offset: 0)
                }
                //系统默认中文输入法会导致英文高亮部分进入输入统计，对输入完成的时候进行字数统计
                if position == nil {
                    //                    FLOG("没有高亮，输入完毕")
                    limitTextLength(textView)
                }
            }else{//非中文输入法
                limitTextLength(textView)
            }
        }else {
            limitTextLength(textView)
        }
        
    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            requestPushlish()
//            return false
//        }else {
//            return true
//        }
//    }

}
