//
//  WOWEditWorksController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/14.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWEditWorksController: WOWBaseViewController {
    
    @IBOutlet weak var imgHeightLayou: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    var modelData : WOWWorksDetailsModel!
    var instagramCategoryId:Int?
    var action:WOWActionClosure?

    var imgSizeId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.view.backgroundColor = UIColor.white
        let itemReghit = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = itemReghit
        
        let tapGestureRecognizer = UIPanGestureRecognizer.init(target: self, action:  #selector(tap))
        
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setUI() {
        super.setUI()
        textView.text = modelData.des
        limitTextLength(textView)
        imgHeightLayou.constant = modelData.picHeight
        imgPhoto.set_webimage_url(modelData.pic ?? "")
    }
    func tap(gestureRecognizer: UIPanGestureRecognizer)  {
        self.view.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    func cancelAction()  {
        
        let alertController = UIAlertController(title: "",
                                                message: "退出此次编辑？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "退出", style: .default, handler: {
            [unowned self] action in
            
            self.dismiss(animated: true) {
            }
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func requestPushWorks(des:String){
        
        WOWNetManager.sharedManager.requestWithTarget(.api_UpdateDescription(workId: modelData.id ?? 0, description: des), successClosure: {[weak self] (result, code) in
            if let strongSelf = self {
                strongSelf.dismiss(animated: true, completion: {
                    print("fanhui")
                })
            }
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
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
        requestPushWorks(des: des)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension WOWEditWorksController:UITextViewDelegate{
    
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
    
    
}
