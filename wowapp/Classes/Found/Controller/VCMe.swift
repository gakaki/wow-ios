

import UIKit

class VCMe:WOWBaseViewController{
    
    var label:UILabel!

    init() {
        
        super.init(nibName: nil, bundle: nil)
        
        label = UILabel()
        label.frame = CGRectMake(50, 150, 200, 21)
        label.backgroundColor = UIColor.orangeColor()
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = "test label"
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
//func magicView(magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
//    let vc = magicView.dequeueReusablePageWithIdentifier(self.identifier_magic_view_page)
//    if (vc == nil) {
//        
//        let vc_me       = VCCategoryProducts()
//        addChildViewController(vc_me)
//        return vc_me
//    }
//    return vc!;
//}