import UIKit
import FlexboxLayout


protocol WOWFoundRecommendCellDelegate:class{
    func notLoginThanToLogin()
    func toProductDetail(productId: Int?)
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
    func setStrokeWithText( str:String ){
        
        let attrString      = NSAttributedString(string: str, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        self.attributedText = attrString

    }
}
class WOWFoundRecommendCell: UITableViewCell {
    
    var product:WOWFoundProductModel?
    var delegate:WOWFoundRecommendCellDelegate?
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        right_label_top.text     = "刀叉五件套1"
        right_label_ceneter.text = "Cutipol12121是家专注于手工餐具制作的老店，起源于葡萄牙幽静的里斯本\n设计方面，它不仅传承了葡萄牙的餐具制作工艺传统，还运用了人体工程学和前沿科技，使产品性能和现代感达到完美融合。\n随着海外消费者的青睐"
        
        right_label_price_stroke.text = ""
        right_label_price_bottom.text = "¥ 378"
        
        
        setUI_btnLike()
        self.prepareViewHierarchy()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func assign_val(p:WOWFoundProductModel){
        
        imageName                            = p.productImg!
        self.iv.set_webimage_url(imageName)
        self.iv.addTapGesture {[weak self] (tap) in
            if let strongSelf = self {
                if let del = strongSelf.delegate {
                    del.toProductDetail(p.productId)
                }
            }
        }
        right_label_top.text                 = p.productName
        right_label_ceneter.text             = p.detailDescription
        right_label_price_stroke.setStrokeWithText(p.get_formted_original_price())
        right_label_price_bottom.text        = p.get_formted_sell_price()

        self.product                         = p
        
        
        if (WOWUserManager.loginStatus){
            self.requestIsFavoriteProduct()
        }else {
            btnLike.selected = false
        }
        
        
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
    var btnLike:UIButton!

    func viewDidLayoutSubviews() {
        self.render()
    }
    
    func render() {
        self.product_view.render()
    }
    
    
    func setUI_btnLike() {
        
        let image                   = UIImage(named: "like-gray") as UIImage?
        let image_selected          = UIImage(named: "like_select") as UIImage?
        
        let button                  = UIButton(type: UIButtonType.Custom)
        button.setImage(image, forState: .Normal)
        button.setImage(image_selected, forState: .Selected)
        
        button.addTarget(self, action: #selector(btn_like_toggle),forControlEvents:.TouchUpInside)
        button.selected = false
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
    
    //用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_IsFavoriteProduct(productId: self.product?.productId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.btnLike.selected = favorite ?? false
            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个单品
    func requestFavoriteProduct()  {
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:self.product?.productId ?? 0), successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.btnLike.selected = !strongSelf.btnLike.selected
                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
            }
        }) { (errorMsg) in
            
            
        }
    }
    


    func prepareViewHierarchy() {
        
        let defaultMargin: Inset = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
//        public typealias Inset = (left: Float, top: Float, right: Float, bottom: Float, start: Float, end: Float)

        iv                       = UIImageView()
        
        self.product_view =  UIView().configure({
            
            $0.style.justifyContent = .SpaceAround
            $0.style.alignSelf      = .FlexStart
            $0.style.margin         = defaultMargin
            $0.style.flexDirection  = .Row
            
            $0.style.dimensions     = Dimension(Float(self.w) ,Float(180.w))
            
            }, children: [
                
                iv.configure({
                    $0.style.dimensions     = ( Float(180.w) , Float(180.w))
                    $0.style.flex           = 1
                }),
                
                UIView().configure({
                    $0.style.flex           = 1
                    $0.style.justifyContent = .SpaceBetween
//                    $0.style.dimensions     = ( Float(180.w) , Float(180.w))
                    $0.style.margin     =  (0, 0.0, 0, 0, 0.0, 8)

                    }, children: [
                        
                        right_label_top.configure({
                            $0.textAlignment = .Left
                            $0.lineBreakMode = .ByWordWrapping
                            $0.numberOfLines = 0
                            $0.setLineHeightAndLineBreak(1.03)
                            
                            $0.font = UIFont.systemScaleFontSize(16)
                            $0.style.alignSelf = .FlexStart
                            $0.style.flex       = 2

                        }),
                        
                        right_label_ceneter.configure({
                            $0.textAlignment    = .Left
                            $0.font             = UIFont.systemScaleFontSize(13)
                            $0.setLineHeightAndLineBreak(1.15)
                            $0.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                            $0.numberOfLines    = 3
                            $0.style.alignSelf  = .FlexStart
                            $0.style.flex       = 5
                            
                        }),
                        
                       right_label_price_stroke.configure({
                            $0.textAlignment    = .Left
                            $0.font             = UIFont.systemScaleFontSize(10)
                            $0.textColor        = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.00)
                            $0.style.alignSelf  = .FlexStart
                            $0.style.flex       = 1.5

                        }),
                        
                        UIView().configure({

                            $0.style.flexDirection  = .Row
                            $0.style.justifyContent = .SpaceBetween
                            $0.style.flex       = 2

                            }, children: [
                                
                                right_label_price_bottom.configure({
                                    $0.textAlignment = .Left
                                    $0.setLineHeightAndLineBreak(1.05)
                                    $0.font = UIFont.systemFontOfSize(14)
                                    $0.style.alignSelf  = .FlexStart

                                }),
                                
                                //                                button.configure({
                                //                                    $0.style.alignSelf  = .FlexStart
                                //                                    $0.style.dimensions = ( 10 , 10)
                                //                                }),
                                
                                btnLike.configure({
                                    $0.style.dimensions = ( Float(32.w) , Float(32.w))
                                    $0.style.alignSelf  = .FlexStart
                                    $0.style.margin     =  (0, Float(-7.h), 0, 0, 0.0, 0)

                                })
                            ])
                    ])
                
            ])
        
        self.addSubview(self.product_view)
    }
}