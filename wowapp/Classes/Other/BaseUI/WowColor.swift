import UIKit


class WowColor:UIColor {
    
    static let gray    = "#CCCCCC"
    static let orange  = "#FFD444"
    
    override class func grayColor() -> UIColor  {
        return UIColor(hexString: gray)!
    }
    override class func orangeColor() -> UIColor  {
        return UIColor(hexString: orange)!
    }
    
}
