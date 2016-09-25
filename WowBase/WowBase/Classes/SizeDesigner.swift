
import UIKit

public extension UIResponder{
    
    public func CGRectMakeD( _ x:Int,y:Int,width:Int,height:Int)-> CGRect{
        let size =  CGRect( x: x.w, y: y.h,  width: width.w,  height: height.h)
        return size
    }
    public func CGSizeD( _ width:Int,height:Int)-> CGSize{
        let size =  CGSize( width: width.w,  height: height.h)
        return size
    }
}

public extension Int{
    
    public var w : CGFloat
    {
        let screen_w = UIScreen.main.bounds.width
        let design_w = CGFloat(375)
        let scale_x  = CGFloat(self) * screen_w / design_w
        return scale_x
    }
    
    public var h : CGFloat{
        
        let screen_h = UIScreen.main.bounds.height
        let design_h = CGFloat(667)
        let scale_y  = CGFloat(self) * screen_h / design_h
        return scale_y
    }
    
}
