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
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var wechatLabel: UILabel!
    @IBOutlet weak var changePwdCell: UITableViewCell!
    @IBOutlet weak var wechatCell:  UITableViewCell!
    @IBOutlet weak var space: NSLayoutConstraint!
    @IBOutlet weak var arrowImg: UIImageView!
    
//    var  backGroundMaskView : UIView!
//    var  backGroundWindow : UIWindow!
    
    var addressInfo                     :WOWAddressListModel?

    
    fileprivate var headImageUrl:String = WOWUserManager.userHeadImageUrl
    fileprivate var nvar        :String = WOWUserManager.userName
    fileprivate var job         :String = WOWUserManager.userIndustry
    fileprivate var sex         :Int    = WOWUserManager.userSex
    fileprivate var des         :String = WOWUserManager.userDes
    fileprivate var star        :Int    = WOWUserManager.userConstellation
    fileprivate var age         :Int    = WOWUserManager.userAgeRange
    
    var pickDataArr:[Int:String] = [Int:String]()
    var editingGroupAndRow:[Int:Int] = [0:0]
    var image:UIImage!
    
//MARK:Lazy
    lazy var imagePicker:UIImagePickerController = {
        let v = UIImagePickerController()
        v.delegate = self
        return v
    }()
    
//    lazy var pickerContainerView :WOWPickerView = {
//        let v = Bundle.main.loadNibNamed("WOWPickerView", owner: self, options: nil)?.last as! WOWPickerView
//        return v
//    }()
    
    //个人资料
    lazy var aboutView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        v.labelText.text = "个人资料"
        return v
    }()
    
    //账号安全
    lazy var accountView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        v.labelText.text = "账号安全"
        return v
    }()
    
    //其他登录方式
    lazy var loginTypeView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        v.labelText.text = "其他登录方式"
        return v
    }()
    
    
    lazy var backView:WOWPickerBackView = {[unowned self] in
        let v = WOWPickerBackView(frame:CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight))
        v.pickerView.pickerView.delegate = self
        v.pickerView.sureButton.addTarget(self, action:#selector(surePicker), for:.touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobClick.e(.Personal_Information)
        
        addObserver()
       


    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        
        MobClick.e(.Personal_Information_Page)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        configUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        removeObserver()

        
        IQKeyboardManager.sharedManager().enable = true


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    fileprivate func addObserver(){
        NotificationCenter.default.addObserver(self, selector:#selector(exitLogin), name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object:nil)
        
    }
    fileprivate func removeObserver() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWExitLoginNotificationKey), object: nil)
    }
    override func setUI() {
        super.setUI()
        navigationItem.title = "账户设置"
        headImageView.borderRadius(25)
        request()
        requestAddressInfo()
        
    }
    
    fileprivate func showPickerView(){
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(backView)
        window?.bringSubview(toFront: backView)
        backView.show()

    }
    
    func refresh_image(){

        
        if   WOWUserManager.userPhotoData.isEmpty {
                    if ( self.image != nil ){
                        self.headImageView.image = self.image
                    }else{

                        self.headImageView.set_webUserPhotoimage_url(WOWUserManager.userHeadImageUrl)
                    }

        }else{
            
            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                
                
                if let myImage = NSKeyedUnarchiver.unarchiveObject(with: WOWUserManager.userPhotoData as Data) as? UIImage {
                    DispatchQueue.main.async { [weak self] () -> Void in
                        self?.headImageView.image = myImage
                    }
                }

            
                
            }
            
            
        }
    }
    fileprivate func configUserInfo(){
        
        self.refresh_image()

        DispatchQueue.main.async {[weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.sexTextField.text  = WOWSex[strongSelf.sex]
                strongSelf.desLabel.text      = WOWUserManager.userDes
                strongSelf.nickLabel.text     = WOWUserManager.userName
                strongSelf.ageTextField.text  = WOWAgeRange[strongSelf.age]
                strongSelf.starTextField.text = WOWConstellation[strongSelf.star]
                strongSelf.jobLabel.text      = WOWUserManager.userIndustry
                if WOWUserManager.userMobile.isEmpty {
                    strongSelf.mobileLabel.text   = "去绑定"
                }else {
                    strongSelf.mobileLabel.text   = WOWUserManager.userMobile.get_formted_xxPhone()
                }
                if WOWUserManager.userWechat {
                    strongSelf.wechatLabel.text = "已绑定"
                    strongSelf.arrowImg.isHidden = true
                    strongSelf.space.constant = 15
                }else {
                    strongSelf.wechatLabel.text = "未绑定"
                    strongSelf.arrowImg.isHidden = false
                    strongSelf.space.constant = 40
                }
                
                strongSelf.ageTextField.isUserInteractionEnabled = false
                strongSelf.sexTextField.isUserInteractionEnabled = false
                strongSelf.starTextField.isUserInteractionEnabled = false
                strongSelf.tableView.reloadData()
            }

        }
    }
    
//MARK:Actions
    func exitLogin() {
        configUserInfo()
    }
    
    func loginSuccess(){
        configUserInfo()
    }

    
    func surePicker() {
        let row = backView.pickerView.pickerView.selectedRow(inComponent: 0)
        
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
        requestEditUserInfo()
        backView.hideView()
    }
    
    func bindMobile()  {
        if WOWUserManager.userMobile.isEmpty {
            VCRedirect.bingMobileSecond(entrance: .userInfo)
        }else {
            VCRedirect.bingMobileFirst()
        }
    }
    
    func bindWechat()  {
       
        guard WOWUserManager.userWechat else {
            
            WowShare.getAuthWithUserInfoFromWechat {[weak self] (response) in
                if let strongSelf = self{
                    //                    if response?.responseCode == UMSResponseCodeSuccess {
                    //
                    strongSelf.requestBindWechat(response as! Dictionary)
                }else{
                    WOWHud.showMsg("授权登录失败")
                }
                
                DLog(response ?? "")
                
            }
            return
        }
       
    }
    
    override func navBack() {
        super.navBack()
  
    }
  //MARK:Private Network
    override func request() {
        super.request()
        //请求默认地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_User, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                strongSelf.configUserInfo()
            }
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.configUserInfo()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }

    }
    
    func requestAddressInfo() {
        //请求默认地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressDefault, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(JSONObject:result)
                if let addressInfo = strongSelf.addressInfo {
                    DLog((addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? ""))
                    strongSelf.addressLabel.text = (addressInfo.province ?? "") + (addressInfo.city ?? "") + (addressInfo.county ?? "")

                }
            }
            
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

    }
    
    func requestEditUserInfo() {
        let params = ["sex":String(sex),"ageRange":String(age),"constellation":String(star),"avatar":self.headImageUrl]
        WOWNetManager.sharedManager.requestWithTarget(.api_Change(param:params), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                WOWHud.dismiss()
                //                let model = Mapper<WOWUserModel>().map(result["user"])
                //                WOWUserManager.saveUserInfo(model)
                //保存一些用户信息
                WOWUserManager.userHeadImageUrl = strongSelf.headImageUrl
                WOWUserManager.userSex = strongSelf.sex
                WOWUserManager.userAgeRange = strongSelf.age
                WOWUserManager.userConstellation = strongSelf.star
                strongSelf.configUserInfo()
                
                
//                if let action = strongSelf.editInfoAction{
//                    action()
//                }
            }
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)

        }

    }
    
    func requestBindWechat(_ userData:Dictionary<String, Any>) {
        
        let open_id        = (userData["openid"] ?? "") as! String
        let unionid        = (userData["unionid"] ?? "") as! String
        let wechatNickName = (userData["nickname"] ?? "") as! String
        let wechatAvatar   = (userData["headimgurl"] ?? "") as! String
        let language        = (userData["language"] ?? "") as! String
        let province        = (userData["province"] ?? "") as! String
        let sex             = (userData["sex"] ?? 3) as! Int
        let country         = (userData["country"] ?? "") as! String
        
        var params              = [String: Any]()
        params = ["openId": open_id, "unionId": unionid, "wechatAvatar": wechatAvatar, "wechatNickName": wechatNickName, "language": language, "province": province, "sex": sex, "country": country]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_BindWechatInfo(params: params as [String : AnyObject]), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("微信绑定成功")
                WOWUserManager.userWechat = true
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                strongSelf.configUserInfo()
                WOWUserManager.userWechat = true
                strongSelf.wechatLabel.text = "已绑定"
                
            }
            
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

    }
    
    


//MARK: - prepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destina = segue.destination as? WOWInfoTextController
        guard let toVC = destina else{
            return
        }
        let segueid = segue.identifier
        switch segueid!{
        case "usernick":
            toVC.entrance = InfoTextEntrance.nickEntrance()
            toVC.userInfo = WOWUserManager.userName
        case "userdesc":
            toVC.entrance = InfoTextEntrance.descEntrance()
            toVC.userInfo = WOWUserManager.userDes
        case "userjob":
            toVC.entrance = InfoTextEntrance.jobEntrance()
            toVC.userInfo = WOWUserManager.userIndustry
        default:break
        }
        toVC.setBackMyClosure {[weak self] (str:String) in
            if let strongSelf = self {
                strongSelf.loginSuccess()

            }
        }
    }

}


extension WOWUserInfoController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (0,0):
            showPicture()
        case (0,3):
            editingGroupAndRow = [0:3]

            pickDataArr = WOWSex
            
            if  sex == 0 {
                backView.pickerView.pickerView.selectRow(2, inComponent: 0, animated: true)
            }else{
                backView.pickerView.pickerView.selectRow(sex - 1, inComponent: 0, animated: true)
            }
           
            backView.pickerView.pickerView.reloadComponent(0)
            showPickerView()

        case (0,4):
            editingGroupAndRow = [0:4]

            pickDataArr = WOWAgeRange
            backView.pickerView.pickerView.selectRow(age, inComponent: 0, animated: true)
            backView.pickerView.pickerView.reloadComponent(0)
            showPickerView()

        case (0,5):
            editingGroupAndRow = [0:5]
            pickDataArr = WOWConstellation
            if star == 0 {
                
                backView.pickerView.pickerView.selectRow(star, inComponent: 0, animated: true)
          
            }else {
                
                backView.pickerView.pickerView.selectRow(star - 1, inComponent: 0, animated: true)
         
            }

            
            backView.pickerView.pickerView.reloadComponent(0)
            showPickerView()

        case (0, 7):
            
            let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWAddressController.self)) as! WOWAddressController
            vc.entrance = WOWAddressEntrance.me
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case (1, 0):
            self.bindMobile()
        case (1, 1):
            let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWMsgCodeController.self)) as! WOWMsgCodeController
            vc.entrance = msgCodeEntrance.userEntrance
            navigationController?.pushViewController(vc, animated: true)
        case (2, 0):
            bindWechat()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return aboutView
        case 1:
            return accountView
        case 2:
            return loginTypeView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 50
        default:
            return 0.01
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 8
        case 1:
            if WOWUserManager.userMobile.isEmpty {
                return 1
            }else {
                return 2
            }

        default:
            return 1
        }
    }
    

    fileprivate func showPicture(){
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
}


//MARK:Delegate
func json_serialize( _ dict:[String:AnyObject]) -> String {
    var str = ""
    
    do {
//        let jsonData        = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonData        = try JSONSerialization.data(withJSONObject: dict, options: [])
         str                = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String

    } catch let error as NSError {
        DLog(error)
    }
    
    return str
}
extension WOWUserInfoController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)

        WOWUploadManager.uploadPhoto(image, successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.headImageUrl = result ?? ""
                strongSelf.requestEditUserInfo()
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateUserHeaderImageNotificationKey, object: nil ,userInfo:["image":image])
                DLog(result ?? "")
            }
            
            
            
            }) { (errorMsg) in
                
                WOWHud.showWarnMsg(errorMsg)

        }
     
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickDataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if editingGroupAndRow == [0:4]  {
            return pickDataArr[row]
        }else{
            return pickDataArr[row + 1]
        }
    }
    
  
}

extension WOWUserInfoController: addressDelegate {
    func editAddress() {
        requestAddressInfo()
    }
}

