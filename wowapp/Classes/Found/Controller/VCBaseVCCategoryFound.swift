

import UIKit


class VCBaseVCCategoryFound:WOWBaseViewController{
    
    
    override func setUI(){
        super.setUI()
        self.configBarItem()
        
    }
    func configBarItem(){
        
        makeCustomerImageNavigationItem("buy", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                strongSelf.toVCCart()
            }
        }
    }

    
    override func loadMore() {
        if isRreshing {
            return
        }else{
            pageIndex += 1
            isRreshing = true
        }
        refresh_view()
    }
    
    func refresh_view(){
        
    }
   
}