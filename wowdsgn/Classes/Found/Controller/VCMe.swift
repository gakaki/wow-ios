

import UIKit

class VCMe:WOWBaseViewController{
    
    var label:UILabel!

    init() {
        
        super.init(nibName: nil, bundle: nil)
        
        label = UILabel()
        label.frame = CGRect(x: 50, y: 150, width: 200, height: 21)
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "test label"
        
        self.view.backgroundColor = UIColor.white
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
