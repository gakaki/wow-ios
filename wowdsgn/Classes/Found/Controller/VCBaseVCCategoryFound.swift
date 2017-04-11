

import UIKit


class VCBaseVCCategoryFound:BaseScreenViewController{
    
    
    override func setUI(){
        super.setUI()
        configBuyBarItem()
        addObserver()
    }
    
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }

   
}
