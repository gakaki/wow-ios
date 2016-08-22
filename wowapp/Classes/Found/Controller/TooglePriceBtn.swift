
import UIKit

class TooglePriceBtn:UIButton {
    
    enum PriceArrowViewStatus : Int {
        case None = 2
        case Up   = 1
        case Down = 0
    }
    
    var _status      = PriceArrowViewStatus.None
    var action : ((PriceArrowViewStatus) -> ())?
    
    var status:PriceArrowViewStatus {
        get {
            return _status
        }
        set(newStatus) {
            _status = newStatus
        }
    }
    
    override func awakeFromNib() {
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(
        frame: CGRect,
        tocuhClosure: (PriceArrowViewStatus) -> ()
        ) {
        
        super.init(frame: frame)
        self.action = tocuhClosure
        setUI()
    }
    
    func touch(){
        self.sendActionsForControlEvents(.TouchUpInside)
        self.highlighted = false
    }
    func state_default(){
        self.highlighted = true
        self.selected = false
    }
    
    func btnTouchInside(){
        
        self.selected = !self.selected
        
        self.status = self.selected ? .Up : .Down
        
        if let a = self.action {
            a(self.status)
        }
        
    }
    
    let wOk = CGFloat(  45 )
    let hOk = CGFloat(  20 )
    
    func setUI(){
        
        self.backgroundColor             = UIColor.whiteColor()
        
        self.setTitle("价格", forState: UIControlState.Normal)
        
        
        
        self.titleLabel!.font            = UIFont.systemFontOfSize(14)
        self.imageEdgeInsets             = UIEdgeInsetsMake(0, 77, 0, 0)
        
        //        self.frame                       = CGRectMake(0, 0, wOk, hOk)
        
        self.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        self.setTitleColor(UIColor.blackColor(), forState: .Selected)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        self.setImage(UIImage(named: "btnPriceStatusNone"), forState: UIControlState.Highlighted)
        self.setImage(UIImage(named: "btnPriceStatusUp"), forState: UIControlState.Selected)
        self.setImage(UIImage(named: "btnPriceStatusDown"), forState: UIControlState.Normal)
        
        self.imageView!.contentMode      = UIViewContentMode.ScaleAspectFill
        //        self.titleLabel!.contentMode     = UIViewContentMode.TopLeft
        self.titleLabel?.textAlignment   = .Center
        //        self.contentHorizontalAlignment  = .Left 有效果
        
        self.addTarget(self, action:#selector(btnTouchInside), forControlEvents:UIControlEvents.TouchUpInside)
        
        self.highlighted = true
        
    }
    
    
    
}