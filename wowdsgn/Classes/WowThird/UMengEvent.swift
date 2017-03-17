

import UIKit

public class AnalyaticEvent {
    public static func e2(_ structEvent:StructDataEvent , _ params: [String : Any] ){
        let event_name = String(describing: structEvent)
        MobClick.event(event_name, attributes: params)
        TalkingData.trackEvent(event_name, label: "AppStore", parameters: params)
    }}
public extension MobClick {

    public static func e(_ countEvent:UMengEvent ){
        let event_name = String(describing: countEvent)
//        print(event_name)
        MobClick.event(event_name)
        TalkingData.trackEvent(event_name, label: "AppStore")

    }

    public static func e2(_ structEvent:UMengEvent , _ params: [String : Any] ){
        let event_name = String(describing: structEvent)
        print(event_name)
        MobClick.event(event_name, attributes: params)
        TalkingData.trackEvent(event_name, label: "AppStore", parameters: params)

    }
 
}

public enum UMengEvent  {
    
    case Brands_List                 //品牌列表
    case Designers_List              //设计师列表
    case Home                        //首页
    case Like                        //喜欢
    case Me                          //我
    case My_Coupons                  //我的礼券
    case My_Orders                   //我的订单
    case Personal_Information        //个人资料
    case Search                      //搜索
    case Search_History_Tags         //搜索历史标签
    case Search_Popular_Tags         //搜索热门标签
    case Selection                   //精选
    case Service_Phone               //客服电话
    case Setting                     //设置
    case Shopping                    //购物
    case Shoppingcart                //购物车
    case Support_Us                  //支持我们
    case Product_Detail              //商品详情
    case H5                          //H5页面
    case Productlist_topic           //导购专题
    case Content_topic               //内容专题
    
    case Message_Center               //消息中心
    case CategoryDetail                 //分类详情
    case AllCategory                //全部分类
    case Home_Page                      //首页
    case Like_Page                        //喜欢
    case Me_Page                          //我
    case Selection_Page                   //灵感
    case Shopping_Page                    //分类
    case Personal_Linfropage_Reg            //个人资料
    case Other_Linfropage_Reg               //其他资料
    case Bind_Phonepage_Reg                 //绑定手机
    case Guide_Page_Reg                     //引导页
    case Immebuy_Button                     //立即购买
    
    case Guide_Join                  //引导页：加入我们
    case Guide_Safari                //引导页：先逛逛
    case Guide_Skip                  //引导页：skip
    case Guide_Wx_Bind               //引导页：绑定微信
    case Guide_Mobile_Reg            //引导页：手机注册
    case Guide_Login                 //引导页：登陆
    
    case Bind_Mobile_Validate        //绑定手机页，获取验证码
    case Bind_Mobile_Bind            //绑定手机页，绑定
    
    case Bind_My_Skip                //个人资料页，跳过
    case Bind_My_Next                //个人资料页，下一步
    
    case Bind_Other_Skip             //其他页，跳过
    case Bind_Other_Succ             //其他页，完成
    
    case Product_Group_Detail_Page      //产品组详情页
    case Space_Detail_Page              //场景详情页
    case Product_Tag_Detail_Page            //标签详情页
    
    case Secondary_Homepage_Pv              //子首页tab
    case Slide_Banners_Clicks	            //轮播
    case Single_Banner_Clicks               //单banner模块
    case Bannerlist_Portrait                //纵向banner组模块
    case Hot_Category_Clicks	            //热门分类模块
    case Brand_Module_Clicks                //品牌专区模块
    case Productlist_Landscape               //横向产品组
    case Productlist_Portrait               //纵向产品组
    case Category_Banner                    //分类banner
    case Category_Option                    //分类选项点击
    
}



