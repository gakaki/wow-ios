
import UIKit


class TooglePriceBtn:UIButton {
    
    var btnIndex:UInt = 0
    
    var asc:Int {
        get {
            return 1
            //TODO
//            return Int(bool:upDown)
        }
    }
    
    var image_is_show:Bool = true{
        didSet{
            if image_is_show == true{
                //显示图片
                self.imageView?.isHidden = false
                self.imageEdgeInsets             = UIEdgeInsetsMake(0, 65, 0, 0)
                self.titleEdgeInsets             = UIEdgeInsetsMake(0, -15, 0, 0)

            }else{
                //不显示图片
                self.imageView?.isHidden = true

                self.setImage(nil, for: UIControlState())
                self.setImage(nil, for: UIControlState.selected)

                
            }
        }
    }
    //UP TRUE DOWN FALSE
    var upDown:Bool = false {
        didSet{
            //有图像的时候在调用 asc 的函数
            if ( image_is_show == true ){
                if upDown == true {
                    self.setImage(UIImage(named: "btnPriceStatusUp"), for: UIControlState.selected)
                }else{
                    self.setImage(UIImage(named: "btnPriceStatusDown"), for: UIControlState.selected)
                }
                
                
            }
            if let a = self.action {
                a(asc) // up 0 down 1
            }
            
        }
    }
    
    var action : ((_ asc:Int) -> ())?
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
        tocuhClosure: @escaping (_ asc:Int) -> ()
    )
    {
        
        super.init(frame: frame)
        self.action = tocuhClosure
        self.in_title = title
        setUI()
    }
    
    func touch(){
        self.sendActions(for: .touchUpInside)
        self.isHighlighted = false
    }

    func btnTouchInside(){

        if ( self.isSelected == true){
             self.upDown = !self.upDown
        }
    }
    
    let wOk = CGFloat(  45 )
    let hOk = CGFloat(  20 )
    
    func setUI(){
        

        self.setTitle( self.in_title, for: UIControlState())
        self.setTitleColor(UIColor.gray, for: UIControlState())
        
        self.setImage(UIImage(named: "btnPriceStatusNone"), for: UIControlState())
        
        self.setTitleColor(UIColor.black, for: .selected)

        
        self.titleLabel!.font            = UIFont.systemFont(ofSize: 14)
//        self.imageEdgeInsets             = UIEdgeInsetsMake(0, 77, 0, 0)
//        self.frame                       = CGRectMake(0, 0, wOk, hOk)
        

        self.imageView!.contentMode      = UIViewContentMode.scaleAspectFill
        //        self.titleLabel!.contentMode     = UIViewContentMode.TopLeft
        self.titleLabel?.textAlignment   = .center
        //        self.contentHorizontalAlignment  = .Left 有效果
        
        self.addTarget(self, action:#selector(btnTouchInside), for:UIControlEvents.touchUpInside)

        
        self.upDown = true
        
    }
    
    
    
}
