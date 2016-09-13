
import VTMagic


class VCVTMagic:VTMagicController{
    
    override func viewDidLoad() {
        
        magicView.navigationColor       = UIColor.whiteColor()
        magicView.sliderColor           = UIColor.blackColor()
        magicView.separatorColor        = UIColor(hexString: "#EAEAEA")
        magicView.layoutStyle           = .Divide
        magicView.switchStyle           = .Default
        magicView.navigationHeight      = 40
        magicView.sliderWidth           = 50
        
        magicView.menuScrollEnabled     = false
        magicView.switchAnimated        = false
        magicView.scrollEnabled         = false

    }
 
}