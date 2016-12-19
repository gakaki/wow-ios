import UIKit
import SnapKit

protocol ModuleViewElement{
    
    static func isNib() -> Bool
    static func cell_type() -> Int
}

struct ModulePageType {
    
    static let PAGE_MODULE_TYPE_CAROUSEL                        = 101;    //    轮播 banner 首页 比例1：1
    static let PAGE_MODULE_TYPE_BANNER                          = 201; 	  //    单条 banner
    static let PAGE_MODULE_TYPE_CATEGORIES                      = 301; 	  //    一级分类
    static let PAGE_MODULE_TYPE_CATEGORIES_MORE                 = 302;	  //    二级分类
    static let PAGE_MODULE_TYPE_NEW_ARRIVAL_RPODUCTS            = 401;    //    本周上新
    static let PAGE_MODULE_TYPE_PINTEREST_PRODUCTS              = 402;	  //    推荐商品
    static let PAGE_MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT        = 501;	  //    单品推荐
    static let PAGE_MODULE_TYPE_TOPIC_PRODUCTS                  = 601;	  //    专题商品列表
    static let PAGE_MODULE_TYPE_PROJECT                         = 102;	  //    专题左右滑动列表
    static let PAGE_MODULE_TYPE_SING_PRODUCT                    = 801;	  //    今日单品倒计时
    static let PAGE_MODULE_TYPE_HOT_STYLE                       = 701;	  //    精选页点赞cell
    static let PAGE_MODULE_TYPE_HOT_COLUMN                      = 901;	  //    尖叫栏目
    static let PAGE_MODULE_TYPE_HOT_PEOPLE                      = 1001;	  //    人气标签，热门标签
    static let PAGE_MODULE_TYPE_HOT_Play                        = 103;	  //    精选页轮播 比例 3：2
    static let PAGE_MODULE_TYPE_CRE_TwoLine                     = 104;	  //    双列产品组
    
    static let d = [

        PAGE_MODULE_TYPE_CAROUSEL 					: HomeBrannerCell.classForCoder(), //轮播 101 banner
        PAGE_MODULE_TYPE_BANNER 					: WOWlListCell.classForCoder(), //单条 201 banner
        PAGE_MODULE_TYPE_CATEGORIES 				: MODULE_TYPE_CATEGORIES_CV_CELL_301.classForCoder(), //301 一级分类
        PAGE_MODULE_TYPE_CATEGORIES_MORE 			: Cell_302_Class.classForCoder(), //302 二级分类
        PAGE_MODULE_TYPE_NEW_ARRIVAL_RPODUCTS 		: WOWFoundWeeklyNewCell.classForCoder(), //401 本周上新
        PAGE_MODULE_TYPE_PINTEREST_PRODUCTS 		: HomeBottomCell.classForCoder(), //402 推荐商品
        PAGE_MODULE_TYPE_SINGLE_RECOMMENT_PRODUCT	: Cell_501_Recommend.classForCoder(), //501 单品推荐
        PAGE_MODULE_TYPE_TOPIC_PRODUCTS				: WOWHomeFormCell.classForCoder(),            //601 专题商品列表
        PAGE_MODULE_TYPE_PROJECT                    : Cell_102_Project.classForCoder(),// 专题左右滑动cell
        PAGE_MODULE_TYPE_SING_PRODUCT               : Cell_801_Product.classForCoder(),// 今日单品倒计时
        PAGE_MODULE_TYPE_HOT_STYLE                  : WOWHotStyleCell.classForCoder(),// 精选页点赞cell
        PAGE_MODULE_TYPE_HOT_COLUMN                 : WOWHotColumnCell.classForCoder(),// 精选页栏目cell
        PAGE_MODULE_TYPE_HOT_PEOPLE                 : WOWHotPeopleCell.classForCoder(),// 精选页点赞cell
        PAGE_MODULE_TYPE_HOT_Play                   : WOWHotBannerCell.classForCoder(),//    精选页轮播 比例 3：2
        PAGE_MODULE_TYPE_CRE_TwoLine                : Cell_104_TwoLine.classForCoder()  //双列产品组 比例自适应
    ]
    // 通过type获取classname
    static func getIdentifier( _ id:Int ) -> String {
        if let d = d[id] {
            return String(describing: d)
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


