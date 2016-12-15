//
//  growing.h
//  Growing
//
//  Created by GrowinIO on 5/3/15.
//  Copyright (c) 2015 GrowingIO. All rights reserved.
//


#import <UIKit/UIKit.h>

#ifndef __cplusplus
@import Foundation;
@import AdSupport;
@import WebKit;
@import CoreTelephony;
@import SystemConfiguration;
@import Foundation;
@import Security;
@import CFNetwork;
@import CoreLocation;
#endif

typedef NS_ENUM(NSInteger, GrowingAspectMode)
{
    // 默认 类似KVO的机制进行数据采集
    // 目前已知对RAC的rac_signalForSelector和Aspects以及部分不确定的手写swizzling有冲突
    // 依据不同调用顺序 可能出现函数不被调用或者崩溃的问题
    // 另外如果使用 object_getClass或者swfit的dynamicType属性会得到一个KVO的子类
    // 如果用于取得XIB或者其他资源 可能会失效
    GrowingAspectModeSubClass           ,
    
    // 测试阶段 高兼容性 性能比GrowingAspectTypeSubClass略低 但是比RAC和Aspects快8-10倍左右
    GrowingAspectModeDynamicSwizzling   ,
};


@interface Growing : NSObject

// SDK版本号
+ (NSString*)sdkVersion;

// 如果您的AppDelegate中 实现了其中一个或者多个方法 请以在已实现的函数中 调用handleUrl
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
// 如果以上所有函数都未实现 则请实现 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation 方法并调用handleUrl
+ (BOOL)handleUrl:(NSURL*)url;

// 请在applicationDidFinishLaunching中调用此函数初始化

// 如果需要采样 设置一个采样值   0.01即1% 0.001即1‰  最多支持小数点后5位
+ (void)startWithAccountId:(NSString *)accountId withSampling:(CGFloat)sampling;

// 默认采样100%
+ (void)startWithAccountId:(NSString *)accountId;



// 命令行输出调试日志
+ (void)setEnableLog:(BOOL)enableLog;
+ (BOOL)getEnableLog;

// 以下四个函数设置后会覆盖原有设置
// 并且只会在第一次安装后调用 以保证同一设备的设备ID相同
// 请在方法 startWithAccountId 之前调用
// 默认使用IDFV，用法：[Growing setDeviceIDModeToIDFV];
#define setDeviceIDModeToIDFV setDeviceIDModeToCustomBlock:^NSString*{ return [[[UIDevice currentDevice] identifierForVendor] UUIDString]; }
// 设置使用IDFA，用法：[Growing setDeviceIDModeToIDFA];
#define setDeviceIDModeToIDFA setDeviceIDModeToCustomBlock:^NSString*{ return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]; }
// 使用随机UUID，用法：[Growing setDeviceIDModeToRandomUUID];
#define setDeviceIDModeToRandomUUID setDeviceIDModeToCustomBlock:^NSString*{ return [[NSUUID UUID] UUIDString]; }
// 使用自定义的ID自 定义ID长度不可大于36 否则会被抛弃 NSUUID的UUIDString长度为36
+ (void)setDeviceIDModeToCustomBlock:(NSString*(^)())customBlock;


// 使用预留字段
+ (void)setCS1Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS2Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS3Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS4Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS5Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS6Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS7Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS8Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS9Value:(NSString*)value forKey:(NSString*)key;
+ (void)setCS10Value:(NSString*)value forKey:(NSString*)key;

// 该函数请在main函数第一行调用 APP启动后 将不允许修改采集模式
+ (void)setAspectMode:(GrowingAspectMode)aspectMode;
+ (GrowingAspectMode)getAspectMode;

// 是否允许发送基本性能诊断信息，默认为开
+ (void)setEnableDiagnose:(BOOL)enable;

+ (void)trackEvent:(NSString *)eventName withValue:(NSDictionary *)keyValuePairs __deprecated_msg("请用下面的 track:properties: 方法");
// 手动发送统计信息，keyValuePairs中的key和value都只能是字符串
+ (void)track:(NSString *)eventName properties:(NSDictionary *)keyValuePairs;

// 全局_不_发送任何统计信息
+ (void)disable;
// 设置为 NO，可以不采集任何关于 UIWebView / WKWebView 的统计信息
+ (void)enableAllWebViews:(BOOL)enable;
// 设置是否发送元素的展现次数（浏览量、曝光量）
+ (void)setImp:(BOOL)imp;

// 设置发送数据的时间间隔（单位为秒）
+ (void)setFlushInterval:(NSTimeInterval)interval;
+ (NSTimeInterval)getFlushInterval;

// 设置一次发送的数据的最多条数
+ (void)setBulkSize:(NSUInteger)size;
+ (NSUInteger)getBulkSize;

// 设置每天使用数据网络（2G、3G、4G）上传的数据量的上限（单位是 KB）
+ (void)setDailyDataLimit:(NSUInteger)numberOfKiloByte;
+ (NSUInteger)getDailyDataLimit;

// 设置自定义的服务器地址
+ (void)setTrackerHost:(NSString *)host;

+ (NSString *)getDeviceId;
+ (NSString *)getSessionId;

@end


// 该属性setter方法均使用 objc_setAssociatedObject实现
// 如果是自定义的View建议优先使用重写getter方法来实现 以提高性能
@interface UIView(GrowingAttributes)

// 手动标识该view不要追踪
@property (nonatomic, assign) BOOL      growingAttributesDonotTrack;

// 手动标识该view不要追踪它的值，默认是NO，特别的UITextView，UITextField，UISearchBar默认是YES
@property (nonatomic, assign) BOOL      growingAttributesDonotTrackValue;

// 手动标识该view的取值  比如banner广告条的id 可以放在banner按钮的任意view上
@property (nonatomic, copy)   NSString* growingAttributesValue;

// 手动标识该view的附加属性  该值可被子节点继承
@property (nonatomic, copy)   NSString* growingAttributesInfo;

// 手动标识该view的tag
// 这个tag必须是全局唯一的，在代码结构改变时也请保持不变
// 这个tag最好是常量，不要包含流水id、SKU-id、商品名称等易变的信息
// 请不要轻易设置这个属性，除非该view在view-tree里的位置不稳定，或者该view在软件的不同版本的view-tree里的位置不一致
@property (nonatomic, copy)   NSString* growingAttributesUniqueTag;

@end


// 该属性setter方法均使用 objc_setAssociatedObject实现
// 如果是自定义的UIViewController建议优先使用重写getter方法来实现 以提高性能
@interface UIViewController(GrowingAttributes)

// 手动标识该vc的附加属性  该值可被子节点继承
@property (nonatomic, copy)   NSString* growingAttributesInfo;

// 手动标识该页面的标题，必须在该UIViewController显示之前设置
@property (nonatomic, copy)   NSString* growingAttributesPageName;

// 手动标识该页面的相关属性，必须在该UIViewController显示之前设置
// growingAttributesPageGroup如果为空，则不会发送PSn属性
@property (nonatomic, copy)   NSString* growingAttributesPageGroup;
@property (nonatomic, copy)   NSString* growingAttributesPS1;
@property (nonatomic, copy)   NSString* growingAttributesPS2;
@property (nonatomic, copy)   NSString* growingAttributesPS3;
@property (nonatomic, copy)   NSString* growingAttributesPS4;
@property (nonatomic, copy)   NSString* growingAttributesPS5;
@property (nonatomic, copy)   NSString* growingAttributesPS6;
@property (nonatomic, copy)   NSString* growingAttributesPS7;
@property (nonatomic, copy)   NSString* growingAttributesPS8;
@property (nonatomic, copy)   NSString* growingAttributesPS9;
@property (nonatomic, copy)   NSString* growingAttributesPS10;

@end



