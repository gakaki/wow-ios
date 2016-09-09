
import UIKit
import SnapKit

class WowBaseVCCartSearch: WOWBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setUI() {
        super.setUI()
        
        self.edgesForExtendedLayout = .None
  
        configBuyBarItem(WOWUserManager.userCarCount)
        addObserver()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateBageCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
    }
    
}

