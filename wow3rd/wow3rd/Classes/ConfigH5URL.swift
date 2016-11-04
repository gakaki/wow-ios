
import Foundation

public struct ConfigH5URL{
    
    public let base_andorid     = "wowdsgn://m.wowdsgn.com/"
    public let base_ios         = "https://m.wowdsgn.com/" //use universal link
    public let base_h5          = "https://m.wowdsgn.com/"
    
//### APP 和 H5 的交互页面URL
    //1 首页
    public let page_main        = "main?page=main"
    public let page_shopping    = "main?page=shopping"
    public let page_hotstyle    = "main?page=hotstyle"
    public let page_favorite    = "main?page=favorite"
    public let page_me          = "main?page=me"

    //1 商品详情页(产品详情)
    public let product_detail   = "product?id=id"
    
    //3 内容专题详情页(专题 图文魂牌)
    public let contenttopic     = "contenttopic?id=id"

    //4 商品列表详情页(系列品)??
    public let group            = "group?id=id"

    //5 品牌详情页
    public let brand            = "brand?id=id"

    //4 设计师详情页
    public let designer         = "designer?id=id"

    //5 优惠券列表
    public let coupon           = "coupon?id=id"

    //6 订单列表
    public let order_list       = "order/list"
    public let order_detail     = "order?id=id"

    //7 分类详情页
    public let category         = "category?id=id"

    //8 APP内H5页
    public let h5               = "h5?url=url"

    
    
}
