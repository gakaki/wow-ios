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
    @IBOutlet weak var categoryTap: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var rightSpace: NSLayoutConstraint!
    
    var modelData : WOWWorksDetailsModel?
    var instagramCategoryId:Int?
    var indexRow: Int = 0
    var categoryArr = [WOWEnjoyCategoryModel]()
    var imgSizeId : Int?
    var instagramCategoryName: String?
    var type:Int = 0    //type = 0时从选择分类页过来。否则从活动页过来
    var topicId: Int = 0        //活动专题id
    var activityName: String?   //活动名称

    lazy var backView:WOWPickerBackView = {[unowned self] in
        let v = WOWPickerBackView(frame:CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight))
        v.pickerView.pickerView.delegate = self
        v.pickerView.sureButton.addTarget(self, action:#selector(surePicker), for:.touchUpInside)
        return v
        }()
    lazy var popWindow:UIWindow = {
        let w = UIApplication.shared.delegate as! AppDelegate
        return w.window!
    }()
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
        if type == 0 {
            //正常分类过来的时候右边是分类
            categoryLabel.text = categoryArr[indexRow].categoryName
            instagramCategoryId = categoryArr[indexRow].id
            arrowImg.isHidden = false
            rightSpace.constant = 34
            categoryTap.addTapGesture {[unowned self] (tap) in
                MobClick.e(.sellect_classifiaction_clicks_post_picture_page)
                self.showPickerView()
            }
        }else {
            //是活动的时候左边是分类，右边是活动名称
            categoryLabel.text = activityName   //填写活动名称
            activityLabel.text = instagramCategoryName      //分类名称
            arrowImg.isHidden = true
            rightSpace.constant = 5
        }

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
    //取消
    func cancelAction()  {
        
        let alertController = UIAlertController(title: "",
                                                message: "退出此次编辑？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "退出", style: .default, handler: {
            [unowned self] action in
            
            self.dismiss(animated: true) {
                MobClick.e(.cancel_post_picture_page)
                _ = FNUtil.currentTopViewController().navigationController?.popViewController(animated: true)
            }
  
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
      
    }
    //显示分类选择
    fileprivate func showPickerView(){
        backView.pickerView.pickerView.selectRow(indexRow, inComponent: 0, animated: true)
        backView.pickerView.pickerView.reloadComponent(0)
//        let window = UIApplication.shared.windows
        
        popWindow.addSubview(backView)
        popWindow.bringSubview(toFront: backView)
        backView.show()
        
    }
    //确认选择
    func surePicker() {
        let row = backView.pickerView.pickerView.selectedRow(inComponent: 0)
        indexRow = row
        let model = categoryArr[row]
        categoryLabel.text = model.categoryName
        instagramCategoryId = model.id
        backView.hideView()
    }
    
    //MARK: - NET

    
    func requestPushWorks(pic:String ,des:String){
        
        var params = [String: Any]()
        params = ["instagramCategoryId": instagramCategoryId ?? 0  ,"pic": pic ,"description":des , "measurement":imgSizeId  ?? 1]

        WOWNetManager.sharedManager.requestWithTarget(.api_PushWorks(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
         
            if let strongSelf = self{
                let r = JSON(result)
                DLog(r)
                
                strongSelf.modelData    =    Mapper<WOWWorksDetailsModel>().map(JSONObject:result)
                
                strongSelf.toWorksDetails(worksId:strongSelf.modelData?.id ?? 0)
            
                
            }
        }) {[weak self] (errorMsg) in
      
             
                WOWHud.showWarnMsg(errorMsg)
                
            
        }

    }
    //活动发布作品
    func requestPushTopicWorks(pic:String ,des:String){
        
        var params = [String: Any]()
        params = ["instagramCategoryId": instagramCategoryId ?? 0  ,"pic": pic ,"description":des , "measurement":imgSizeId  ?? 1, "topicId": topicId]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_PublishTopicWorks(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
         
            if let strongSelf = self{
                let r = JSON(result)
                DLog(r)
                
                strongSelf.modelData    =    Mapper<WOWWorksDetailsModel>().map(JSONObject:result)
                
                strongSelf.toWorksDetails(worksId:strongSelf.modelData?.id ?? 0)
                
                
            }
        }) {[weak self] (errorMsg) in
            
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
        WOWHud.showLoadingSV()
        WOWUploadManager.uploadShareImg(photo, successClosure: {[weak self] (url) in
            
            if let strongSelf = self {
                WOWHud.showLoadingSV()
                if strongSelf.type == 0 {
                    strongSelf.requestPushWorks(pic: url ?? "", des: des)

                }else {
                    strongSelf.requestPushTopicWorks(pic: url ?? "", des: des)

                }
            }
            
            
        }) { (error) in
            WOWHud.dismiss()
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
extension WOWReleaseWorksController: UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
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

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = categoryArr[row]
        return model.categoryName
        
    }

}
