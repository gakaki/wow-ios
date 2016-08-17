

//VCManager
extension UIViewController
{
   
    func toVCCategory( cid: String = "10" , cname:String ){
        let vc      = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(VCCategory)) as! VCCategory
        vc.cid      = cid
        vc.title    = cname
        self.pushVC(vc)
     }
    
    
    func toVCProduct( pid: Int? ){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        self.pushVC(vc)
    }
    
    
    func toVCCart( ){
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        pushVC(vc)
    }
   
    
    func toVCTopic( topic_id:Int? ){
        if let t = topic_id {
            let vc                  = VCTopic(nibName: nil, bundle: nil)
            vc.topic_id             = t
            vc.hideNavigationBar    = true
            self.pushVC(vc)
        }
        
    }
    

}