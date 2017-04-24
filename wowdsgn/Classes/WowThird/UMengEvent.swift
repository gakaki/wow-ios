

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
    
    case Search_Results                 //搜索结果页
    case Cart_Detail_Page               //购物车详情页
    case Information_Center_Page            // 消息中心页
    case Brands_Detail_Page             //品牌详情页
    case Designers_Detail_Page           //设计师详情页
    case Coupons_Page                   //优惠券列表页
    case Delivery_Address_Page          //收货地址页
    case Personal_Information_Page          //个人信息页
    case Coupons_Detail_Page                //优惠券可用商品详情页
    case Add_To_Cart                        //加入购物车
    case Buy_It_Now                         //立即购买
    case Standard_Confirm                   //选择规格
    case Standard_Cancel                    //选择规格取消
    case Buy_Clicks                           //购物车结算
    case Selectnumber_Clicks               //选择商品数量按钮
    case Delectproduct_Clicks               //删除按钮
    case Select_All_Clicks                   //全选按钮
    case Registration_Successful             //注册成功
    case Add_To_Cart_Successful             //加车成功
    case Orders_Submitted                   //提交订单
    case Orders_Payment                     //支付订单

    
    
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
    
    case masterpiece_page_community_homepage   //佳作页（社区首页）
    case select_classification_masterpiece_page  //筛选分类按钮（佳作页)
    case upload_picture_clicks_masterpiece_page     //上传佳作按钮（佳作页）
    case latest_picture_page                        //最新页
    case dislike_clicks_latest_picture_page        //左划不喜欢按钮（最新页）
    case like_clicks_latest_picture_page            //右划赞按钮（最新页）
    case refresh_clicks_latest_picture_page         //刷新按钮（最新页）
    case upload_classified_picture_page             //选择上传分类页
    case sellect_classifiaction_clicks_upload_classified_picture_page       //分类选项按钮（选择上传分类页）
    case next_clicks_upload_classified_picture_page     //下一步（选择上传分类页）
    case select_picture_page                            //选择图片页
    case takephoto_clicks                           //拍照按钮（选择图片页）
    case finishpicturebutton                        //完成按钮（选择图片页）
    case edit_picture_page                          //编辑图片页
    case turning_picture_clicks_edit_picture_page       //旋转图片按钮（编辑图片页）
    case cut_picture_clicks_edit_picture_page           //裁剪图片按钮（编辑图片页）
    case select_size_clicks_edit_picture_page           //比例选项按钮（编辑图片页）
    case next_edit_picture_page                         //下一步（编辑图片页）
    case post_picture_page                              //编辑文字页（发布）
    case cancel_post_picture_page                       //取消（发布页）
    case post_clicks_post_picture_page                  //发布按钮（发布页）
    case sharepicture_popup                             //分享弹窗
    case moments_clicks_sharing_page                    //朋友圈按钮（分享页）
    case wx_friends_clicks_sharing_page                  //微信好友（分享页）
    case picture_details_page                            //作品详情页    
    case avatars_clicks_picture_details_page                //用户头像点击（作品详情页）
    case thumbs_up_clicks_picture_details_page              //点赞（作品详情页）
    case collection_clicks_picture_details_page             //收藏（作品详情页） 
    case sharing_clicks_picture_details_page                //分享（作品详情页）
    case my_personalpicture_page                                //个人作品页（自己）
    case other_personalpicture_page                         //个人作品页（其他人）
    case picture_uploadlist_clicks                          //已上传tab点击
    case picture_uploaddetail_clicks                        //已上传详情tab点击
    case savepicture_clicks                                 //收藏的作品tab点击
    case change_personal_information_clicks_my_homepage         //修改个人信息按钮（个人中心页）

    case more_button_picture_details_page                   //更多按钮（作品详情页）
    case edit_picture_details_page                          //编辑（作品详情页）
    case delete_picture_details_page                        //删除（作品详情页）
    case report_picture_details_page                        //举报（作品详情页）
    case garbage_information_picture_details_page           //垃圾信息（作品详情页）
    case inappropriate_content_picture_details_page         //内容不当（作品详情页）
    case reedit_picture_page                                //重新编辑页
    case cancel_reedit_picture_page                         //取消（重新编辑图片页）
    case post_reedit_picture_page                           //发布（重新编辑图片页）
    case double_clicks_picture_details_page                 //作品双击点赞（作品详情页）
    case double_clicks_masterpiece_page_community_homepage  //作品双击点赞（佳作页）
    case online_customer_service_button_product_detail      //在线客服按钮（商品详情页）
    case contact_customer_service_order_detail              //联系客服按钮（订单详情页）
    case customer_service_phone_order_detail                //客服电话按钮（订单详情页）
    case online_customer_service_order_detail               //在线客服按钮（订单详情页）
    case contact_customer_service_edit_order                //联系客服按钮（填写订单页）
    case customer_service_phone_edit_order                  //客服电话按钮（填写订单页）
    case online_customer_service_edit_order                 //在线客服按钮（填写订单页）
    case online_customer_service_information_center_page    //在线客服（消息中心）
    case online_cutomer_service_detailpage                  //在线客服对话框	
    
}



