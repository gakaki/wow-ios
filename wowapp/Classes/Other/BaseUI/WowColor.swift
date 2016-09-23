import UIKit


class WowColor:UIColor {
    
    static let gray         = "#CCCCCC"
    static let grayLight    = "#808080"
    static let orange       = "#FFD444"
    static let black        = "#202020"
    static let blackLight   = "#000000"
    
    override class func gray() -> UIColor  {
        return UIColor(hexString: gray)!
    }
    override class func orange() -> UIColor  {
        return UIColor(hexString: orange)!
    }
    override class func black() -> UIColor  {
        return UIColor(hexString: black)!
    }
    class func blackLight() -> UIColor  {
        return UIColor(hexString: blackLight)!
    }
    
    class func grayLight() -> UIColor  {
        return UIColor(hexString: grayLight)!
    }

}
