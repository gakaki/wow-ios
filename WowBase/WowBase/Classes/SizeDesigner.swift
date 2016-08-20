
import UIKit

extension Int{
    
    var w : CGFloat
    {
        let screen_w = UIScreen.mainScreen().bounds.width
        let design_w = CGFloat(375)
        let scale_x  = CGFloat(self) * screen_w / design_w
        return scale_x
    }
    
    var h : CGFloat{
        
        let screen_h = UIScreen.mainScreen().bounds.height
        let design_h = CGFloat(667)
        let scale_y  = CGFloat(self) * screen_h / design_h
        return scale_y
    }
    
}
