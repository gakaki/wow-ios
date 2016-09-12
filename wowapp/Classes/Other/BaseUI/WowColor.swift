import UIKit


class WowColor:UIColor {
    
    static let gray         = "#CCCCCC"
    static let grayLight    = "#808080"
    static let orange       = "#FFD444"
    static let black        = "#202020"
    static let blackLight   = "#000000"
    
    override class func grayColor() -> UIColor  {
        return UIColor(hexString: gray)!
    }
    override class func orangeColor() -> UIColor  {
        return UIColor(hexString: orange)!
    }
    override class func blackColor() -> UIColor  {
        return UIColor(hexString: black)!
    }
    class func blackLightColor() -> UIColor  {
        return UIColor(hexString: blackLight)!
    }
    
    class func grayLightColor() -> UIColor  {
        return UIColor(hexString: grayLight)!
    }

}
