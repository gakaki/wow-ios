

import UIKit

public extension MobClick {

    public static func e(_ countEvent:UMengEvent ){
        let event_name = String(describing: countEvent)
        print(event_name)
        MobClick.event(event_name)
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
    case MessageCenter               //消息中心

    
    case GUIDE_JOIN                     //引导页：加入我们
    case GUIDE_SAFRARI                  //引导页：先逛逛
    case GUIDE_SKIP                     //引导页：skip
    case GUIDE_WX_BIND                  //引导页：绑定微信
    case GUIDE_MOBILE_REG               //引导页：手机注册
    case GUIDE_LOGIN                    //引导页：登陆
    
    case BIND_MOBILE_VALIDATE_CODE      //绑定手机页，获取验证码
    case BIND_MOBILE_BIND               //绑定手机页，绑定
    
    case BIND_MY_INFO_SKIP              //个人资料页，跳过
    case BIND_MY_INFO_NEXT              //个人资料页，下一步
    
    case BIND_PAGE_OTHER_INFO_SKIP      //其他页，跳过
    case BIND_PAGE_OTHER_INFO_SUCC      //其他页，完成
  
}



