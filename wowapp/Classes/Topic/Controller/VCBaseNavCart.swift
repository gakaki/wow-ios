
import UIKit

class VCBaseNavCart:WOWBaseViewController{
    
    let btn_width_height = CGFloat(44)
    var carEntranceButton:MIBadgeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config_btn_back()
        config_btn_cart()
        buyCarCount()
        addObservers()
        self.edgesForExtendedLayout = .None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        
    }
    deinit {
        removeObservers()
    }
    
    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(buyCarCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
    }
    private func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWUpdateCarBadgeNotificationKey, object: nil)
    }

    let offset_icon = {
      return UIApplication.sharedApplication().statusBarFrame.height
    }
    let offset_width = CGFloat(10)

    func config_btn_back(){
        let image       = UIImage(named: "top_back")! as UIImage
        let button      = UIButton(type:.Custom)
        button.frame    = CGRectMake(offset_width, offset_icon(), btn_width_height, btn_width_height)
        button .setBackgroundImage(image, forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(btn_back_action), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func config_btn_cart(){
        let image       = UIImage(named: "top_car")! as UIImage
        carEntranceButton      = MIBadgeButton(type: .Custom)
        carEntranceButton.frame    = CGRectMake(self.view.frame.width - btn_width_height - offset_width, offset_icon(), btn_width_height, btn_width_height)
        carEntranceButton .setBackgroundImage(image, forState: UIControlState.Normal)
        carEntranceButton.addTarget(self, action:#selector(btn_cart_action), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(carEntranceButton)
    }
    
    func btn_back_action(){
        self.navBack()
    }
    func btn_cart_action(){
        toVCCart()
    }
    
    func buyCarCount()  {
        if WOWUserManager.userCarCount <= 0 {
            carEntranceButton.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            
            carEntranceButton.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carEntranceButton.badgeString = "99+"
        }
    }
    
   

}