
import UIKit


class TooglePriceBtn:UIButton {
    
    var btnIndex:UInt = 0
    
    var asc:Int {
        get {
            return Int(upDown)
        }
    }
    
    var image_is_show:Bool = true{
        didSet{
            if image_is_show == true{
                //显示图片
                self.imageView?.hidden = false
                self.imageEdgeInsets             = UIEdgeInsetsMake(0, 65, 0, 0)
                self.titleEdgeInsets             = UIEdgeInsetsMake(0, -15, 0, 0)

            }else{
                //不显示图片
                self.imageView?.hidden = true

                self.setImage(nil, forState: UIControlState.Normal)
                self.setImage(nil, forState: UIControlState.Selected)

                
            }
        }
    }
    //UP TRUE DOWN FALSE
    var upDown:Bool = false {
        didSet{
            //有图像的时候在调用 asc 的函数
            if ( image_is_show == true ){
                if upDown == true {
                    self.setImage(UIImage(named: "btnPriceStatusUp"), forState: UIControlState.Selected)
                }else{
                    self.setImage(UIImage(named: "btnPriceStatusDown"), forState: UIControlState.Selected)
                }
                
                
            }
            if let a = self.action {
                a(asc: asc) // up 0 down 1
            }
            
        }
    }
    
    var action : ((asc:Int) -> ())?
    var in_title:String = "价格"
    

    override func awakeFromNib() {
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    init(
        title:String = "价格",
        frame: CGRect,
        tocuhClosure: (asc:Int) -> ()
    )
    {
        
        super.init(frame: frame)
        self.action = tocuhClosure
        self.in_title = title
        setUI()
    }
    
    func touch(){
        self.sendActionsForControlEvents(.TouchUpInside)
        self.highlighted = false
    }

    func btnTouchInside(){

        if ( self.selected == true){
             self.upDown = !self.upDown
        }
    }
    
    let wOk = CGFloat(  45 )
    let hOk = CGFloat(  20 )
    
    func setUI(){
        

        self.setTitle( self.in_title, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        self.setImage(UIImage(named: "btnPriceStatusNone"), forState: UIControlState.Normal)
        
        self.setTitleColor(UIColor.blackColor(), forState: .Selected)

        
        self.titleLabel!.font            = UIFont.systemFontOfSize(14)
//        self.imageEdgeInsets             = UIEdgeInsetsMake(0, 77, 0, 0)
//        self.frame                       = CGRectMake(0, 0, wOk, hOk)
        

        self.imageView!.contentMode      = UIViewContentMode.ScaleAspectFill
        //        self.titleLabel!.contentMode     = UIViewContentMode.TopLeft
        self.titleLabel?.textAlignment   = .Center
        //        self.contentHorizontalAlignment  = .Left 有效果
        
        self.addTarget(self, action:#selector(btnTouchInside), forControlEvents:UIControlEvents.TouchUpInside)

        
        self.upDown = true
        
    }
    
    
    
}