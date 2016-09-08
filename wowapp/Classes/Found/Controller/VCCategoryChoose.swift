

import UIKit

class VCCategoryChoose:WOWBaseViewController{
    
    var label:UILabel!
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        
        label = UILabel()
        label.frame = CGRectMake(50, 150, 200, 21)
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "test label"
        
        self.view.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
