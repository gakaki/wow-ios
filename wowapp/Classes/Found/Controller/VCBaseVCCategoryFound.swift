

import UIKit


class VCBaseVCCategoryFound:WOWBaseViewController{
    
    
    override func setUI(){
        super.setUI()
        configBuyBarItem()
        addObserver()
    }
    
    private func addObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateBageCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
        
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