

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
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        let nav_vc = UINavigationController(rootViewController: vc)
        vc.hideNavigationBar = false
//        self.presentVC(nav_vc)
        self.pushVC(nav_vc)
    }
    
    
    func toVCTopic( ){
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        let nav_vc = UINavigationController(rootViewController: vc)
        vc.hideNavigationBar = false
        self.pushVC(nav_vc)
    }
    

}