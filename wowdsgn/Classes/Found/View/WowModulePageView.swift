import UIKit
import SnapKit

protocol ModuleViewElement{
    //    func setModel(m:ModuleData)
    //    func show()
    static func isNib() -> Bool
    static func cell_type() -> Int
}


//轮播 101 banner
class MODULE_TYPE_CAROUSEL_CV_CELL_101:UITableViewCell,ModuleViewElement
{
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int { return 101 }
}

//201 单品banner
class MODULE_TYPE_SINGLE_BANNER_CELL_201:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
    static func cell_type() -> Int { return 201 }
    
    var product:WowModulePageItemVO?
    var bigImageView: UIImageView = UIImageView()
    var heightAll:CGFloat   = MGScreenWidth
//    var delegate:MODULE_TYPE_CAROUSEL_CV_CELL_101_Delegate?
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
   
        addSubview(bigImageView)
        
        bigImageView.snp.makeConstraints { (make) in
//            make.size.equalTo(MGScreenWidth)
//            make.center.equalTo(self)
            make.top.bottom.left.right.equalTo(self)
        }
//        
        bigImageView.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        bigImageView.addGestureRecognizer(singleTap)
    }
    func singleTapAction(){
////        if let del = self.delegate {
////            del.MODULE_TYPE_CAROUSEL_CV_CELL_101_cell_touch(product)
////        }
//        
        self.viewController()?.toVCProduct(product?.bannerLinkTargetId)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ p:WowModulePageItemVO){
        self.product = p
        bigImageView.set_webimage_url(p.bannerImgSrc)
    }
   
}

//402 推荐商品
//class MODULE_TYPE_PINTEREST_PRODUCTS_CV_CELL_402:UITableViewCell,ModuleViewElement{
//    static func isNib() -> Bool { return false }
//    static func cell_type() -> Int { return 402 }
//
//}

//501 单品推荐
class MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT_CV_CELL_501:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
    static func cell_type() -> Int { return 501 }
}

//601 专题商品列表
class MODULE_TYPE_TOPIC_PRODUCTS_CV_CELL_601:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
    static func cell_type() -> Int { return 601 }

}

struct ModulePageType {
    
    static let PAGE_MODULE_TYPE_CAROUSEL                        = 101;    //轮播 banner
    static let PAGE_MODULE_TYPE_BANNER                          = 201; 	  //单条 banner
    static let PAGE_MODULE_TYPE_CATEGORIES                      = 301; 	  // 一级分类
    static let PAGE_MODULE_TYPE_CATEGORIES_MORE                 = 302;	  // 二级分类
    static let PAGE_MODULE_TYPE_NEW_ARRIVAL_RPODUCTS            = 401;    //本周上新
    static let PAGE_MODULE_TYPE_PINTEREST_PRODUCTS              = 402;	  //推荐商品
    static let PAGE_MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT        = 501;	  //单品推荐
    static let PAGE_MODULE_TYPE_TOPIC_PRODUCTS                  = 601;	  //专题商品列表
    static let PAGE_MODULE_TYPE_PROJECT                         = 102;	  //专题 左右滑动列表
    static let PAGE_MODULE_TYPE_SING_PRODUCT                    = 801;	  //今日单品倒计时
    static let d = [

        PAGE_MODULE_TYPE_CAROUSEL 					: MODULE_TYPE_CAROUSEL_CV_CELL_101.classForCoder(), //轮播 101 banner
        PAGE_MODULE_TYPE_BANNER 					: MODULE_TYPE_SINGLE_BANNER_CELL_201.classForCoder(), //单条 201 banner
        PAGE_MODULE_TYPE_CATEGORIES 				: MODULE_TYPE_CATEGORIES_CV_CELL_301.classForCoder(), //301 一级分类
        PAGE_MODULE_TYPE_CATEGORIES_MORE 			: Cell_302_Class.classForCoder(), //302 二级分类
        PAGE_MODULE_TYPE_NEW_ARRIVAL_RPODUCTS 		: WOWFoundWeeklyNewCell.classForCoder(), //401 本周上新
        PAGE_MODULE_TYPE_PINTEREST_PRODUCTS 		: HomeBottomCell.classForCoder(), //402 推荐商品
        PAGE_MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT	: Cell_501_Recommend.classForCoder(), //501 单品推荐
        PAGE_MODULE_TYPE_TOPIC_PRODUCTS				: MODULE_TYPE_TOPIC_PRODUCTS_CV_CELL_601.classForCoder(),            //601 专题商品列表
        PAGE_MODULE_TYPE_PROJECT :Cell_102_Project.classForCoder(),
        PAGE_MODULE_TYPE_SING_PRODUCT:Cell_103_Product.classForCoder()
        
        
    ]

    static func getIdentifier( _ id:Int ) -> String {
        if let d = d[id] {
            return NSStringFromClass(d)
        }
        return ""
    }
    static func getPageView( _ pageType:Int ) -> ModuleViewElement?
    {
        if let p = d[pageType] {
            print( p )
        }
        return nil
    }
}


