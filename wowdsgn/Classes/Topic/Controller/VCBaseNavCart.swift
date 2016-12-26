
import UIKit

class VCBaseNavCart:WOWBaseViewController{
    
    let btn_width_height = CGFloat(44)
    var carEntranceButton:MIBadgeButton!
    var newView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config_btn_back()
        config_btn_cart()
        config_btn_msg()
        buyCarCount()
        addObservers()
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    deinit {
        removeObservers()
    }
    
    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector:#selector(buyCarCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
    }
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
    }

    let offset_icon = {
      return UIApplication.shared.statusBarFrame.height + 10
    }
    let offset_width = CGFloat(10)

    func config_btn_back(){
        let image       = UIImage(named: "top_back")! as UIImage
        let button      = UIButton(type:.custom)
        button.frame    = CGRect(x: offset_width, y: offset_icon(), width: btn_width_height, height: btn_width_height)
        button .setBackgroundImage(image, for: UIControlState())
        button.addTarget(self, action:#selector(btn_back_action), for:UIControlEvents.touchUpInside)
        self.view.addSubview(button)
    }
    
    func config_btn_cart(){
        let image       = UIImage(named: "top_car")! as UIImage
        carEntranceButton      = MIBadgeButton(type: .custom)
        carEntranceButton.frame    = CGRect(x: self.view.frame.width - btn_width_height - offset_width, y: offset_icon(), width: btn_width_height, height: btn_width_height)
        carEntranceButton .setBackgroundImage(image, for: UIControlState())
        carEntranceButton.addTarget(self, action:#selector(btn_cart_action), for:UIControlEvents.touchUpInside)
        self.view.addSubview(carEntranceButton)
    }
    
    func config_btn_msg(){
        let image       = UIImage(named: "message_topic")! as UIImage
        let button      = UIButton(type:.custom)
        button.frame    = CGRect(x: self.view.frame.width - 2*(btn_width_height + offset_width), y: offset_icon(), width: btn_width_height, height: btn_width_height)
        button .setBackgroundImage(image, for: UIControlState())
        button.addTarget(self, action:#selector(btn_msg_action), for:UIControlEvents.touchUpInside)
        newView = UIView(frame: CGRect(x: btn_width_height - 4, y: 4, width: 8, height: 8))
        button.addSubview(newView)
        self.view.addSubview(button)

    }
    
    func btn_back_action(){
        self.navBack()
    }
    func btn_cart_action(){
        toVCCart()
    }
    func btn_msg_action(){
        toVCMessageCenter()
    }
    
    func buyCarCount()  {
        if WOWUserManager.userCarCount <= 0 {
            carEntranceButton.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carEntranceButton.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carEntranceButton.badgeString = "99+"
        }
        //如果未登录状态下，不显示
        guard WOWUserManager.loginStatus else {
            newView.isHidden = true
            return
        }
        if WOWUserManager.systemMsgCount + WOWUserManager.userMsgCount > 0 {
            newView.isHidden = false
        }else {
            newView.isHidden = true
        }
    }
    
    

}
