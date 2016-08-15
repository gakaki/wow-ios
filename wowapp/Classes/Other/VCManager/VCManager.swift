

//VCManager
extension UIViewController
{
   
    func toVCCategory( cid: String = "10"){
        let vc = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(VCCategory)) as! VCCategory
        vc.cid     = cid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func toVCProduct( pid: Int? ){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
}