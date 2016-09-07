import UIKit

protocol ModuleViewElement{
    //    func setModel(m:ModuleData)
    //    func show()
    static func isNib() -> Bool
}

//轮播 101 banner
class MODULE_TYPE_CAROUSEL_CV_CELL_101:UITableViewCell,ModuleViewElement
{
    static func isNib() -> Bool { return true }
}

//单条 201 banner
class MODULE_TYPE_BANNER_CV_CELL_201:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
}

//301 一级分类
class MODULE_TYPE_CATEGORIES_CV_CELL_301:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
}



//402 推荐商品
class MODULE_TYPE_PINTEREST_PRODUCTS_CV_CELL_402:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }

}

//501 单品推荐
class MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT_CV_CELL_501:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }

}

//601 专题商品列表
class MODULE_TYPE_TOPIC_PRODUCTS_CV_CELL_601:UITableViewCell,ModuleViewElement{
    static func isNib() -> Bool { return false }
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
    
    static let d = [

        PAGE_MODULE_TYPE_CAROUSEL 					: MODULE_TYPE_CAROUSEL_CV_CELL_101.classForCoder(), //轮播 101 banner
        PAGE_MODULE_TYPE_BANNER 					: MODULE_TYPE_BANNER_CV_CELL_201.classForCoder(), //单条 201 banner
        PAGE_MODULE_TYPE_CATEGORIES 				: MODULE_TYPE_CATEGORIES_CV_CELL_301.classForCoder(), //301 一级分类
        PAGE_MODULE_TYPE_CATEGORIES_MORE 			: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302.classForCoder(), //302 二级分类
        PAGE_MODULE_TYPE_NEW_ARRIVAL_RPODUCTS 		: WOWFoundWeeklyNewCell.classForCoder(), //401 本周上新
        PAGE_MODULE_TYPE_PINTEREST_PRODUCTS 		: MODULE_TYPE_PINTEREST_PRODUCTS_CV_CELL_402.classForCoder(), //402 推荐商品
        PAGE_MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT	: MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT_CV_CELL_501.classForCoder(), //501 单品推荐
        PAGE_MODULE_TYPE_TOPIC_PRODUCTS				: MODULE_TYPE_TOPIC_PRODUCTS_CV_CELL_601.classForCoder()            //601 专题商品列表
    ]

    static func getIdentifier( id:Int ) -> String {
        if let d = d[id] {
            return NSStringFromClass(d)
        }
        return ""
    }
    static func getPageView( pageType:Int ) -> ModuleViewElement?
    {
        if let p = d[pageType] {
            print( p )
        }
        return nil
    }
}


