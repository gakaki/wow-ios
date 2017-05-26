import UIKit
import wow_vendor_ui

protocol WOWFoundRecommendCellDelegate:class{
    func notLoginThanToLogin()
    func toProductDetail(_ productId: Int?)
}

extension Double {
    var intStr:String {
        get {
            return String(format:"%.f",self)
        }
    }
    var doubleStr:String {
        get {
            return String(format:"%.2f",self)
        }
    }
    
    var intYuan:String {
        get {
            let str = self.intStr
            return "¥ \(str)"
        }
    }
}
extension UILabel{
    func setStrokeWithText( _ str:String ){
        var s = ""
        if str != "" {
            s = "¥" + str
        }
        let attrString      = NSAttributedString(string:s, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        self.attributedText = attrString

    }
}


// 单品推荐
class WOWFoundRecommendCell: UITableViewCell {
    static func cell_type() -> Int {
        return 501
    }
    var product:WowModulePageItemVO?
    var delegate:WOWFoundRecommendCellDelegate?
    var heightAll   = 180.h
    static func isNib() -> Bool { return false }

    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
//        right_label_top.text     = "刀叉五件套1"
//        right_label_ceneter.text = "Cutipol12121是家专注于手工餐具制作的老店，起源于葡萄牙幽静的里斯本\n设计方面，它不仅传承了葡萄牙的餐具制作工艺传统，还运用了人体工程学和前沿科技，使产品性能和现代感达到完美融合。\n随着海外消费者的青睐"
        
//        right_label_price_stroke.text = ""
//        right_label_price_bottom.text = "¥ 378"
        
        
        setUI_btnLike()
        self.prepareViewHierarchy()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()


    }
    
    func setData(_ p:WowModulePageItemVO){
        
        imageName                            = p.productImg!
        self.iv.set_webimage_url(imageName)
      
        self.iv.addTapGesture {[weak self] (tap) in
            if let strongSelf = self {
                if let del = strongSelf.delegate {
                      DLog(strongSelf.iv.frame)
                     DLog(strongSelf.btnLike.frame)
                    del.toProductDetail(p.productId)
                }
            }
        }
        right_label_top.text                 = p.productName
        right_label_ceneter.text             = p.detailDescription
        /// 如果原价大于售价显示原价并加下划线，如果没有原价或是等于售价不显示
        if let price = p.sellPrice {
            if let originalPrice = p.originalPrice {
                if originalPrice > price{
                    right_label_price_stroke.isHidden = false
                    right_label_price_stroke.setStrokeWithText(p.get_formted_original_price())
                }
            }else {
                right_label_price_stroke.isHidden = true
                right_label_price_stroke.text = ""

            }
        }
        right_label_price_bottom.text        = p.get_formted_sell_price()
        self.btnLike.isSelected = p.favorite ?? false
        self.product                         = p
        
      
        
        render()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
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
    var btnLike:UIButton!

    func viewDidLayoutSubviews() {
        self.render()

    }
    
    func render() {
        self.product_view.render()
    }
    
    
    func setUI_btnLike() {
        
        let button = LikeBtn.init(frame: CGRect.zero)
        
        button.addTarget(self, action: #selector(btn_like_toggle),for:.touchUpInside)

        btnLike                     = button
        self.addSubview(btnLike)
    }
    
    func btn_like_toggle(){
//        if let del = self.delegate {
//            del.notLoginThanToLogin()
//            return
//        }
        guard WOWUserManager.loginStatus else {
            UIApplication.currentViewController()?.toLoginVC(true)
            return
        }
        requestFavoriteProduct()

    }
    
   
    //用户喜欢某个单品
    func requestFavoriteProduct()  {
        
//        WOWHud.showLoadingSV()

        let btn = LikeBtn.init(frame: CGRect.zero)
        btn.alpha = 0.0
        self.contentView.addSubview(btn)
        var offSet = 7
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            offSet = 7
        case .dt_iPhone6:
            offSet = 8
        case .dt_iPhone6_Plus:
            offSet = 9
        default:
            break
        }
        
        btn.snp.makeConstraints { [weak self](make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(32)
                make.height.equalTo(32)
                make.bottom.equalTo(strongSelf).offset(-(offSet + 1).h)
                make.right.equalTo(strongSelf).offset(-offSet.w)
            }
            
        }
        WOWClickLikeAction.requestFavoriteProduct(productId: self.product?.productId ?? 0,view: self.contentView,btn: btn, isFavorite: { [weak self](isFavorite) in

            if let strongSelf = self{
                
               strongSelf.btnLike.isSelected  = isFavorite!
                
            }
        })

    }

    func prepareViewHierarchy() {
        

        iv                             = UIImageView()

        self.product_view =  UIView().define(children: [
        
            iv.define() { v in
                v.style.dimensions     = ( Float(180.w) , Float(180.w))
                v.style.flex           = 1
            },
            
            UIView().define( children: [
            
                right_label_top.define(){ v in
                    
                    v.textAlignment 		= .left
                    v.lineBreakMode 		= .byWordWrapping
                    v.numberOfLines 		= 0
                    v.setLineHeightAndLineBreak(1.03)
                    
                    v.font 					= UIFont.systemScaleFontSize(16)
                    v.style.alignSelf       = .flexStart
                    v.style.flex            = 2
                    
                },
                    
                    
                right_label_ceneter.define(){ v in
                    v.textAlignment    = .left
                    v.font             = UIFont.systemScaleFontSize(13)
                    v.setLineHeightAndLineBreak(1.15)
                    v.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                    v.numberOfLines    = 3
                    v.style.alignSelf  = .flexStart
                    v.style.flex       = 5
                    
                },
                    
                    
                right_label_price_stroke.define(){ v in
                    v.textAlignment    = .left
                    v.font             = UIFont.systemScaleFontSize(10)
                    v.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                    v.style.alignSelf  = .flexStart
                    v.style.flex       = 1.5
                },
                    
                    
                    
                UIView().define(children: [
                    
                        right_label_price_bottom.define() { v in
                            v.textAlignment = .left
                            v.setLineHeightAndLineBreak(1.05)
                            v.font = UIFont.systemFont(ofSize: 14)
                            v.style.alignSelf  = .flexStart
                        },
                        
                        //button.define() { v in
                        //    v.style.alignSelf  = .FlexStart
                        //    v.style.dimensions = ( 10 , 10)
                        //}),
                        
                        btnLike.define() { v in
                            v.style.dimensions = ( Float(32.w) , Float(32.w))
                            v.style.alignSelf  = .flexStart
                            v.style.margin     =  (0, Float(-7.h), 0, 0, 0.0, 0)
                        
                        }
                    
                ]) { v in
                    
                        v.style.flexDirection  = .row
                        v.style.justifyContent = .spaceBetween
                        v.style.flex           = 2
                    
                }
                    
            
            ]) { v in
            
                v.style.flex           = 1
                v.style.justifyContent = .spaceBetween
                //v.style.dimensions     = ( Float(180.w) , Float(180.w))
                v.style.margin     		 =  (0, 0.0, 0, 0, 0.0, 8)
            }
        
        
        ]) { v in
            
            v.style.justifyContent = .spaceAround
            v.style.alignSelf      = .flexStart
            v.style.margin         = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            v.style.flexDirection  = .row
            
            v.style.dimensions     = Dimension(Float(self.w) ,Float(180.w))
            
        }

        
        self.addSubview(self.product_view)

    }
}
//收藏btn
class LikeBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image                   = UIImage(named: "like-gray") as UIImage?
        let image_selected          = UIImage(named: "like_select") as UIImage?
    
        self.setImage(image, for: UIControlState())
        self.setImage(image_selected, for: .selected)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
