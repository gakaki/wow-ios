

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
    
  
}



