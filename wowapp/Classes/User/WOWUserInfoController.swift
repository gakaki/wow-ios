//
//  WOWUserInfoController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
//import PromiseKit
import Qiniu
import Alamofire
import Hashids_Swift
import FCUUID
import IQKeyboardManagerSwift

let PickerViewHeight : CGFloat   =    250

class WOWUserInfoController: WOWBaseTableViewController {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    //个性签名
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var  backGroundMaskView : UIView!
    var  backGroundWindow : UIWindow!
    
    var editInfoAction:WOWActionClosure?
    var addressInfo                     :WOWAddressListModel?

    
    private var headImageUrl:String = WOWUserManager.userHeadImageUrl
    private var nick        :String = WOWUserManager.userName
    private var job         :String = WOWUserManager.userIndustry
    private var sex         :Int = WOWUserManager.userSex
    private var des         :String = WOWUserManager.userDes
    private var star        :Int = WOWUserManager.userConstellation
    private var age         :Int = WOWUserManager.userAgeRange
    
    var pickDataArr:[Int:String] = [Int:String]()
    var editingGroupAndRow:[Int:Int] = [0:0]
    var image:UIImage!
    
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
        
        addObserver()
        configUserInfo()
       


    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
//        self.refresh_image()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        let imageData:NSData = NSKeyedArchiver.archivedDataWithRootObject(image)
//        let userDefault = NSUserDefaults.standardUserDefaults()
//        userDefault.setObject("", forKey: "imageData")
        
        
        
        
            configPickerView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        removeObserver()
        backGroundMaskView.removeFromSuperview()
        pickerContainerView.removeFromSuperview()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
//        self.refresh_image()
        
        self.headImageView.image = nil
        self.headImageView.setNeedsDisplay()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(loginSuccess), name:WOWLoginSuccessNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(exitLogin), name:WOWExitLoginNotificationKey, object:nil)
        
    }
    private func removeObserver() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWExitLoginNotificationKey, object: nil)
    }
    override func setUI() {
        super.setUI()
        navigationItem.title = "个人信息"
        headImageView.borderRadius(25)
        requestAddressInfo()
        
    }
    
    private func configPickerView(){
        
        backGroundMaskView = UIView()
        backGroundMaskView.frame = CGRectMake(0, 0 , MGScreenWidth, MGScreenHeight)
        backGroundMaskView.backgroundColor = UIColor.blackColor()
        backGroundMaskView.alpha = 0.2
        
//        backGroundMaskView.tag == 1000

        backGroundMaskView.addTapGesture(target: self, action: #selector(cancelPicker))
        
        pickerContainerView.frame = CGRectMake(0, MGScreenHeight,UIApplication.currentViewController()?.view.w ?? MGScreenWidth, PickerViewHeight)
        

        pickerContainerView.pickerView.delegate = self
        pickerContainerView.cancelButton.addTarget(self, action:#selector(cancelPicker), forControlEvents:.TouchUpInside)
        pickerContainerView.sureButton.addTarget(self, action:#selector(surePicker), forControlEvents:.TouchUpInside)

//        pickerContainerView.tag == 1001 
        
        backGroundWindow = UIApplication.sharedApplication().keyWindow
        
        backGroundWindow.addSubview(backGroundMaskView)
        backGroundWindow.addSubview(pickerContainerView)
        backGroundMaskView.hidden = true

    }
    
    func refresh_image(){
        
        self.headImageView.image = nil
        self.headImageView.setNeedsDisplay()

        if   WOWUserManager.userPhotoData.length == 0 {
                    if ( self.image != nil ){
                        self.headImageView.image = self.image
                    }else{
                        self.headImageView.set_webimage_url_user( WOWUserManager.userHeadImageUrl )
                    }

        }else{
            dispatch_async(dispatch_get_main_queue()) {

            let myImage = NSKeyedUnarchiver.unarchiveObjectWithData(WOWUserManager.userPhotoData) as! UIImage
            
            self.headImageView.image = myImage
            }
        }
    }
    private func configUserInfo(){
        
        self.refresh_image()

        dispatch_async(dispatch_get_main_queue()) {
            
            self.sexTextField.text  = WOWSex[self.sex]
            self.desLabel.text      = WOWUserManager.userDes
            self.nickLabel.text     = WOWUserManager.userName
            self.ageTextField.text  = WOWAgeRange[self.age]
            self.starTextField.text = WOWConstellation[self.star]
            self.jobLabel.text      = WOWUserManager.userIndustry
    
            
            self.ageTextField.userInteractionEnabled = false
            self.sexTextField.userInteractionEnabled = false
            self.starTextField.userInteractionEnabled = false
            self.tableView.reloadData()
        }
    }
    
//MARK:Actions
    func exitLogin() {
        configUserInfo()
    }
    
    func loginSuccess(){
        configUserInfo()
    }
    func cancelPicker(){

        self.backGroundMaskView.hidden = true
        UIView.animateWithDuration(0.3){
            self.pickerContainerView.mj_y = MGScreenHeight
        }
    }
    
    func surePicker() {
        let row = pickerContainerView.pickerView.selectedRowInComponent(0)
        
        if editingGroupAndRow == [0:3] {
            
            sex = row + 1
            
            sexTextField?.text = pickDataArr[row + 1]
            
        }else if editingGroupAndRow == [0:4]{
            
            age = row
            
            ageTextField?.text = pickDataArr[row]
            
        }else if editingGroupAndRow == [0:5] {
            star = row + 1
            
            starTextField?.text = pickDataArr[row + 1]
        }
        request()
        cancelPicker()
    }
    
    func saveWithFile(strImg:String) {
        // 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        // 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString;
        // 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent("data.plist");
        let dataSource = NSMutableArray();
        dataSource.addObject(strImg);
//        dataSource.addObject("为伊消得人憔悴");
//        dataSource.addObject("故国不堪回首明月中");
//        dataSource.addObject("人生若只如初见");
//        dataSource.addObject("暮然回首，那人却在灯火阑珊处");
        // 4、将数据写入文件中
        dataSource.writeToFile(filePath, atomically: true);
    }
    func readWithFile() {
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString;
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString;
        /// 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent("data.plist");
        let dataSource = NSArray(contentsOfFile: filePath);
        print(dataSource);
    }
//MARK:Private Network
    override func request() {
        super.request()
        let params = ["sex":String(sex),"ageRange":String(age),"constellation":String(star),"avatar":self.headImageUrl]
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
          
                
                if let action = strongSelf.editInfoAction{
                    action()
                }
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
            DLog(errorMsg)
        }
       
    }
    
    func requestAddressInfo() {
        //请求默认地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDefault, successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(result)
                if let addressInfo = strongSelf.addressInfo {
                    DLog((addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? ""))
                    strongSelf.addressLabel.text = (addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? "")
                    let section = NSIndexSet(index: 1)
                    strongSelf.tableView.reloadSections(section, withRowAnimation: .None)
                }
            }
            
        }) { (errorMsg) in
            
        }

    }
    


//MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destina = segue.destinationViewController as? WOWInfoTextController
        guard let toVC = destina else{
            return
        }
        let segueid = segue.identifier
        switch segueid!{
        case "usernick":
            toVC.entrance = InfoTextEntrance.NickEntrance()
            toVC.userInfo = WOWUserManager.userName
        case "userdesc":
            toVC.entrance = InfoTextEntrance.DescEntrance()
            toVC.userInfo = WOWUserManager.userDes
        case "userjob":
            toVC.entrance = InfoTextEntrance.JobEntrance()
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
        case (0,3):
            pickDataArr = WOWSex
            
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(sex - 1, inComponent: 0, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(0)
            showPickerView()
            editingGroupAndRow = [0:3]

        case (0,4):
            pickDataArr = WOWAgeRange
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(age, inComponent: 0, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(0)

            showPickerView()
            editingGroupAndRow = [0:4]
        case (0,5):
            pickDataArr = WOWConstellation
            self.pickerContainerView.pickerView.reloadComponent(0)
            pickerContainerView.pickerView.selectRow(star - 1, inComponent: 0, animated: true)
            self.pickerContainerView.pickerView.reloadComponent(0)
            showPickerView()
            editingGroupAndRow = [0:5]
        case (1, 0):
            
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWAddressController)) as! WOWAddressController
            vc.entrance = WOWAddressEntrance.Me
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 15
    }
    private func showPickerView(){
        
        self.backGroundMaskView.hidden = false
        
        UIView.animateWithDuration(0.3){
            self.pickerContainerView.mj_y = self.view.h - PickerViewHeight + 64

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
}


//MARK:Delegate
func json_serialize( dict:[String:AnyObject]) -> String {
    var str = ""
    
    do {
//        let jsonData        = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonData        = try NSJSONSerialization.dataWithJSONObject(dict, options: [])
         str                = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String

    } catch let error as NSError {
        DLog(error)
    }
    
    return str
}
extension WOWUserInfoController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = image.fixOrientation()
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
        
        
        let onlyStr = FCUUID.uuidForDevice() + (NSDate().timeIntervalSince1970 * 1000).toString
        let hashids                 = Hashids(salt:onlyStr)
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
            
//            self.headImageView.image =  image

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
                        self.image               =  image
//                        self.saveWithFile(self.headImageUrl)
                        let imageData:NSData = NSKeyedArchiver.archivedDataWithRootObject(image)
//                        let userDefault = NSUserDefaults.standardUserDefaults()
//                        userDefault.setObject(imageData, forKey: "imageData")
                        WOWUserManager.userPhotoData = imageData
                        NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateUserHeaderImageNotificationKey, object: nil ,userInfo:["image":image])
                        
                        self.request()
                    }
                    
                    
                },
                option: uploadOption
            )
            
        }

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickDataArr.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if editingGroupAndRow == [0:4]  {
            return pickDataArr[row]
        }else{
            return pickDataArr[row + 1]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        if editingGroupAndRow == [0:3] {
            
//            sex = row + 1

//            sexTextField?.text = pickDataArr[row + 1]
            
        }else if editingGroupAndRow == [0:4]{
            
//            age = row

//            ageTextField?.text = pickDataArr[row]

        }else if editingGroupAndRow == [0:5] {
//            star = row + 1

//            starTextField?.text = pickDataArr[row + 1]
        }
    }
    
  
}
extension WOWUserInfoController{
  }
extension WOWUserInfoController: addressDelegate {
    func editAddress() {
        requestAddressInfo()
    }
}

