
import VTMagic


class VCCategoryTabBar:VTMagicController{
    
    override func viewDidLoad() {
        
        magicView.navigationColor   = UIColor.whiteColor()
        magicView.sliderColor       = UIColor.blackColor()
        magicView.layoutStyle       = .Default;
        magicView.switchStyle       = .Default;
        magicView.navigationHeight  = 35;
        
        
    }
}