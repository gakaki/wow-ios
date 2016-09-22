

import UIKit


class VCBaseVCCategoryFound:WOWBaseViewController{
    
    
    override func setUI(){
        super.setUI()
        configBuyBarItem()
        addObserver()
    }
    
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }

    override func loadMore() {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
    }
    
   
}
