
import UIKit
import FlexboxLayout
import YYWebImage


extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}


public enum FontWeight {
    case Normal
    case Regular
    case Bold
    case Black
    case Heavy
    case Semibold
    case Thin
    case Light
    case UltraLight
}

extension UIFont {
    
    @available(iOS 7, *)
    public class func systemFontOfSize(size: Double, weight: FontWeight) -> UIFont {
        if #available(iOS 8.2, *) {
            let fontWeightFloat: CGFloat
            switch weight {
            case .UltraLight:
                fontWeightFloat = UIFontWeightUltraLight
            case .Light:
                fontWeightFloat = UIFontWeightLight
            case .Thin:
                fontWeightFloat = UIFontWeightThin
            case .Normal:
                fontWeightFloat = UIFontWeightRegular
            case .Regular:
                fontWeightFloat = UIFontWeightMedium
            case .Semibold:
                fontWeightFloat = UIFontWeightSemibold
            case .Bold:
                fontWeightFloat = UIFontWeightBold
            case .Heavy:
                fontWeightFloat = UIFontWeightHeavy
            case .Black:
                fontWeightFloat = UIFontWeightBlack
            }
            
            return UIFont.systemFontOfSize(CGFloat(size), weight: fontWeightFloat)
        } else {
            let systemFontName: String
            switch weight {
            case .UltraLight:
                systemFontName = "HelveticaNeue-UltraLight"
            case .Light:
                systemFontName = "HelveticaNeue-Light"
            case .Thin:
                systemFontName = "HelveticaNeue-Thin"
            case .Normal:
                systemFontName = "HelveticaNeue"
            case .Regular:
                systemFontName = "HelveticaNeue-Medium"
            case .Semibold:
                systemFontName = "HelveticaNeue-Medium"
            case .Bold:
                systemFontName = "HelveticaNeue-Bold"
            case .Heavy:
                systemFontName = "HelveticaNeue-Bold"
            case .Black:
                systemFontName = "HelveticaNeue-Bold"
            }
            
            return UIFont(name: systemFontName, size: CGFloat(size))!
        }
    }
    
}


protocol WOWFoundRecommendCellDelegate:class{
    func cellTouchInside(m:WOWFoundProductModel)
}
class WOWFoundRecommendCell: UITableViewCell {
    
    var product:WOWFoundProductModel?
    weak var delegate:WOWFoundRecommendCellDelegate?

    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        right_label_top.text                 = p.productName
        right_label_ceneter.text             = p.detailDescription
        right_label_price_stroke.text        = "¥ \(p.originalPrice)"
        right_label_price_bottom.text        = "¥ \(p.sellPrice)"
        
        self.prepareViewHierarchy()
        render()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var imageName:String = ""
    var product_view    =  UIView()
    var iv:UIImageView = UIImageView()
    var right_label_top:UILabel = UILabel()
    var right_label_ceneter:UILabel = UILabel()
    var right_label_price_stroke:UILabel = UILabel()
    var right_label_price_bottom:UILabel = UILabel()
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
        
        self.product_view.removeFromSuperview()
        
        let defaultMargin: Inset = (8.0, -20.0, 8.0, 8.0, 8.0, 8.0)
        iv                       = UIImageView()
        let url                  = NSURL(string:self.imageName ?? "")
        iv.yy_setImageWithURL(url , placeholder: UIImage(named: "placeholder_product"))
        
        let screen_w             = Float( self.w )
        
        right_label_top.text     = "自然系列 A型桌 单个装系列自然系列 A型桌 单个装系列"
        
        right_label_ceneter.text = "自然系列 A型桌 单个装系列自然系列 A型桌 单个装系列系列 A型桌 列自然系列 A型桌 单个装系列自然系列 A型桌 单个装系列系列 A型桌 列"
        right_label_ceneter.lineBreakMode = .ByTruncatingTail
        
        right_label_price_stroke.text = "¥ 123123"
        right_label_price_bottom.text = "¥ 123123"
        
        
        button.backgroundColor = UIColor.blackColor()
        button.setTitle("Button", forState: UIControlState.Normal)
        button.addTarget(self, action:#selector(self.buttonClicked), forControlEvents: .TouchUpInside)
        
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
            
            $0.style.maxDimensions.width = ~( CGFloat(screen_w)  - 20)
            }, children: [
                
                iv.configure({
                    //                    $0.backgroundColor = UIColor.a
                    //                    $0.layer.cornerRadius = 12.0
                    $0.style.dimensions     = ( 160 , 160)
                    $0.style.margin         = defaultMargin
                    $0.style.alignSelf      = .FlexStart
                    $0.style.justifyContent = .FlexStart
                    $0.style.flex           = 0.9
                }),
                
                UIView().configure({
                    //                    $0.backgroundColor      = UIColor.a
                    $0.style.alignSelf      = .Center
                    $0.style.flex           = 1
                    $0.style.justifyContent = .SpaceBetween
                    $0.style.dimensions     = ( 160 , 160)
                    }, children: [
                        
                        right_label_top.configure({
                            $0.textAlignment = .Left
                            $0.lineBreakMode = .ByWordWrapping
                            $0.numberOfLines = 0
                            $0.setLineHeight(1.05)
                            
                            $0.font = UIFont.systemFontOfSize(15, weight: FontWeight.Bold)
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                        }),
                        
                        right_label_ceneter.configure({
                            $0.textAlignment    = .Left
                            $0.font             = UIFont.systemFontOfSize(10, weight: FontWeight.Bold)
                            //                            $0.lineBreakMode = .ByWordWrapping
                            $0.lineBreakMode    = .ByTruncatingTail //隐藏尾部并显示省略号
                            $0.setLineHeight(1.15)
                            $0.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                            $0.numberOfLines    = 3
                            //                            $0.style.alignSelf  = .FlexStart
                            $0.style.margin     = defaultMargin
                        }),
                        
                        right_label_price_stroke.configure({
                            $0.textAlignment = .Center
                            $0.font = UIFont.systemFontOfSize(8, weight: FontWeight.Bold)
                            $0.textColor = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                            $0.style.alignSelf = .FlexStart
                            $0.style.margin = (0,4.0, 0, -13, 8.0, 0)
                            
                            //显示下划线
                            let attrString = NSAttributedString(string: "¥ 123123", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
                            $0.attributedText = attrString
                            
                        }),
                        
                        UIView().configure({
                            //                            $0.style.alignSelf      = .FlexEnd
                            $0.style.flexDirection  = .Row
                            
                            }, children: [
                                
                                right_label_price_bottom.configure({
                                    $0.textAlignment = .Left
                                    $0.setLineHeight(1.05)
                                    //                                    $0.style.flex = 0.9
                                    $0.font = UIFont.systemFontOfSize(10, weight: FontWeight.Bold)
                                    $0.style.alignSelf = .FlexStart
                                    $0.style.margin = (0, 4.0, 0, 0, 8.0, 0)
                                }),
                                
                                button.configure({
                                    $0.style.alignSelf  = .FlexStart
                                    $0.style.dimensions = ( 10 , 10)
                                    $0.style.margin     =  (0, 5.0, 0, 0, 8.0, 0)
                                }),
                                
                                button_share.configure({
                                    $0.style.alignSelf  = .FlexStart
                                    $0.style.dimensions = ( 10 , 10)
                                    $0.style.margin     =  (0, 5.0, 0, 0, 8.0, 0)
                                    
                                })
                            ])
                    ])
                
            ])
        
        self.addSubview(self.product_view)
    }
}