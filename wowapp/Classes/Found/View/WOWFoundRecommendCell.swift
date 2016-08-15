import UIKit
import FlexboxLayout
import YYWebImage


protocol WOWFoundRecommendCellDelegate:class{
    func cellTouchInside(m:WOWFoundProductModel)
}
class WOWFoundRecommendCell: UITableViewCell {
    
    var product:WOWFoundProductModel?
    weak var delegate:WOWFoundRecommendCellDelegate?

    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        right_label_top.text     = "刀叉五件套1"
        right_label_ceneter.text = "Cutipol12121是家专注于手工餐具制作的老店，起源于葡萄牙幽静的里斯本\n设计方面，它不仅传承了葡萄牙的餐具制作工艺传统，还运用了人体工程学和前沿科技，使产品性能和现代感达到完美融合。\n随着海外消费者的青睐"
        
        right_label_price_stroke.text = ""
        right_label_price_bottom.text = "¥ 378"
        

        self.prepareViewHierarchy()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
           super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func assign_val(p:WOWFoundProductModel){
        
     
        
        imageName                            = p.productImg!
        self.iv.set_webimage_url(imageName)
        right_label_top.text                 = p.productName
        right_label_ceneter.text             = p.detailDescription
        right_label_price_stroke.text        = p.get_formted_original_price()
        right_label_price_bottom.text        = p.get_formted_sell_price()
        
        
        
        render()
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var imageName:String = ""
    var product_view                        = UIView()
    var iv:UIImageView                      = UIImageView()
    var right_label_top:UILabel             = UILabel()
    var right_label_ceneter:UILabel         = UILabel()
    var right_label_price_stroke:UILabel    = UILabel()
    var right_label_price_bottom:UILabel    = UILabel()
    var button:UIButton = UIButton()
    var button_share:UIButton = UIButton()
    
    
    func buttonClicked(){
        print ("buttonClicked")
        if let del = self.delegate {
            del.cellTouchInside(self.product!)
        }
    }
    func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        self.product_view.render()
//        self.product_view.center = self.center
    }

    func prepareViewHierarchy() {
        
        
        let defaultMargin: Inset = (8.0, 8.0, 8.0, 8.0, 8.0, 8.0)
        
        iv                       = UIImageView()
        
//        button.backgroundColor = UIColor.blackColor()
//        button.setTitle("Button", forState: UIControlState.Normal)
//        button.addTarget(self, action:#selector(self.buttonClicked), forControlEvents: .TouchUpInside)
      
        button_share.backgroundColor = UIColor.blackColor()
        button_share.setTitle("Button", forState: UIControlState.Normal)
        button_share.addTarget(self, action:#selector(self.buttonClicked), forControlEvents: .TouchUpInside)
        
        self.product_view =  UIView().configure({
            
            $0.backgroundColor      = UIColor.whiteColor()
            $0.layer.borderColor    = UIColor.whiteColor().CGColor
            $0.layer.borderWidth    = 2.0
            $0.style.justifyContent = .Center
            $0.style.alignSelf      = .Stretch
            $0.style.margin         = defaultMargin
            $0.style.flexDirection  = .Row
            
            //            $0.style.maxDimensions.width = ~( CGFloat(screen_w)  - 20)
            //            $0.style.maxDimensions.height = ~( CGFloat(screen_h)  / 3)
            
            $0.style.dimensions     = Dimension(Float(self.w) - 10,200)
            
            }, children: [
                
                iv.configure({
                    //                    $0.backgroundColor = UIColor.a
                    //                    $0.layer.cornerRadius = 12.0
                    //                    $0.style.dimensions     = ( 160 , 160)
                    //                    $0.style.margin         = defaultMargin
                    //                    $0.style.alignSelf      = .FlexStart
                    //                    $0.style.justifyContent = .FlexStart
                    $0.style.flex           = 1.2
                }),
                
                UIView().configure({
                    //                    $0.backgroundColor      = UIColor.a
                    //                    $0.style.alignSelf      = .Center
                    $0.style.flex           = 1
                    $0.style.justifyContent = .SpaceAround
                    //                    $0.style.dimensions     = ( 160 , 160)
                    
                    }, children: [
                        
                        right_label_top.configure({
                            $0.textAlignment = .Left
                            $0.lineBreakMode = .ByWordWrapping
                            $0.numberOfLines = 0
                            $0.setLineHeightAndLineBreak(1.05)
                            
                            $0.font = UIFont.systemScaleFontSize(15)
                            $0.style.alignSelf = .FlexStart
                            $0.style.flex           = 1
                            
                            //                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        right_label_ceneter.configure({
                            $0.textAlignment    = .Left
                            $0.font             = UIFont.systemScaleFontSize(10)
                            $0.setLineHeightAndLineBreak(1.15)
                            $0.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                            $0.numberOfLines    = 3
                            $0.style.alignSelf  = .FlexStart
                            $0.style.dimensions = ( 160 , 60)
                            $0.style.flex           = 2
                            
                            //                            $0.style.margin     = defaultMargin
                        }),
                        
                        //                       right_label_price_stroke.configure({
                        //                            $0.textAlignment = .Center
                        //                            $0.font = UIFont.systemFontOfSize(8, weight: UIFontWeightLight)
                        //                            $0.textColor = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                        //                            $0.style.alignSelf = .FlexStart
                        //                            $0.style.margin = (0,4.0, 0, -13, 8.0, 0)
                        //
                        //                            //显示下划线
                        //                            let attrString = NSAttributedString(string: "¥ 123123", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
                        //                            $0.attributedText = attrString
                        //
                        //                        }),
                        
                        UIView().configure({
                            //                            $0.style.alignSelf      = .FlexEnd
                            $0.style.flexDirection  = .Row
                            //                            $0.style.alignSelf  = .Stretch
                            $0.style.justifyContent = .SpaceBetween
                            $0.style.flex           = 1
                            
                            }, children: [
                                
                                right_label_price_bottom.configure({
                                    $0.textAlignment = .Left
                                    $0.setLineHeightAndLineBreak(1.05)
                                    //                                    $0.style.flex = 0.9
                                    $0.font = UIFont.systemFontOfSize(10)
                                    $0.style.alignSelf = .FlexStart
                                    $0.style.margin = (0, 4.0, 0, 0, 0.0, 0)
                                }),
                                
                                //                                button.configure({
                                //                                    $0.style.alignSelf  = .FlexStart
                                //                                    $0.style.dimensions = ( 10 , 10)
                                //                                    $0.style.margin     =  (0, 5.0, 0, 0, 8.0, 0)
                                //                                }),
                                
                                button_share.configure({
                                    $0.style.alignSelf  = .FlexStart
                                    $0.style.dimensions = ( 10 , 10)
                                    $0.style.margin     =  (0, 5.0, 0, 0, 0.0,20)
                                    
                                })
                            ])
                    ])
                
            ])
        
        self.addSubview(self.product_view)
    }
}