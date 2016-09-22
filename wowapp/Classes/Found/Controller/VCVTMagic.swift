
import VTMagic


class VCVTMagic:VTMagicController{
    
    override func viewDidLoad() {
        
        magicView.navigationColor       = UIColor.white
        magicView.sliderColor           = UIColor.black
        magicView.separatorColor        = UIColor(hexString: "#EAEAEA")
        magicView.layoutStyle           = .divide
        magicView.switchStyle           = .default
        magicView.navigationHeight      = 40
        magicView.sliderWidth           = 50
        
        magicView.isMenuScrollEnabled     = false
        magicView.isSwitchAnimated        = false
        magicView.isScrollEnabled         = false

    }
 
}
