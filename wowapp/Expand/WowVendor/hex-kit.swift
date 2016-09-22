import UIKit

extension String {
    
    public var CGColor: CGColor {
        return self.CGColor(1)
    }
    
    public var UIColor: UIKit.UIColor {
        return self.UIColor(1)
    }
    
    public func CGColor (_ alpha: CGFloat) -> CGColor {
        return self.UIColor(alpha).cgColor
    }
    
    public func UIColor (_ alpha: CGFloat) -> UIKit.UIColor {
        var hex = self
        
        if hex.hasPrefix("#") { // Strip leading "#" if it exists
            hex = hex.substring(from: hex.characters.index(after: hex.startIndex))
        }
        
        switch hex.characters.count {
        case 1: // Turn "f" into "ffffff"
            hex = hex._repeat(6)
        case 2: // Turn "ff" into "ffffff"
            hex = hex._repeat(3)
        case 3: // Turn "123" into "112233"
            hex = hex[0]._repeat(2) + hex[1]._repeat(2) + hex[2]._repeat(2)
        default:
            break
        }
        
        assert(hex.characters.count == 6, "Invalid hex value")
        
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        Scanner(string: "0x" + hex[0...1]).scanHexInt32(&r)
        Scanner(string: "0x" + hex[2...3]).scanHexInt32(&g)
        Scanner(string: "0x" + hex[4...5]).scanHexInt32(&b)
        
        let red = CGFloat(Int(r)) / CGFloat(255.0)
        let green = CGFloat(Int(g)) / CGFloat(255.0)
        let blue = CGFloat(Int(b)) / CGFloat(255.0)
        
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

private extension String {
    
    func _repeat (_ count: Int) -> String {
        return "".padding(toLength: (self as NSString).length * count, withPad: self, startingAt:0)
    }
    
    subscript (i: Int) -> String {
        return String(Array(arrayLiteral: self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
}
