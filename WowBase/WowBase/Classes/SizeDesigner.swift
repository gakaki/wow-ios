
import UIKit

public extension UIResponder{
    
    public func CGRectMakeD( x:Int,y:Int,width:Int,height:Int)-> CGRect{
        let size =  CGRectMake( x.w, y.h,  width.w,  height.h)
        return size
    }
    public func CGSizeD( width:Int,height:Int)-> CGSize{
        let size =  CGSizeMake( width.w,  height.h)
        return size
    }
}

public extension Int{
    
    public var w : CGFloat
    {
        let screen_w = UIScreen.mainScreen().bounds.width
        let design_w = CGFloat(375)
        let scale_x  = CGFloat(self) * screen_w / design_w
        return scale_x
    }
    
    public var h : CGFloat{
        
        let screen_h = UIScreen.mainScreen().bounds.height
        let design_h = CGFloat(667)
        let scale_y  = CGFloat(self) * screen_h / design_h
        return scale_y
    }
    
}