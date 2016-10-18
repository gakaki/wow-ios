/**
 
 需要适配的地方 替换 CGRectMake => CGRectMakeAdapt  \
 e.g.   button.frame = CGRectMake(100, 100, 100, 100);
 =>  button.frame = CGRectMakeAdapt(100, 100, 100, 100)
 
 */

#import <UIKit/UIKit.h>

/** 适配 与设计图物理宽度比较 */
@interface UIResponder (Adapt)

#pragma mark - 默认模式为iPhone5的设计图



/*!
 @brief  水平比例适配
 @param level 原值
 @return 适配后的值
 */
CGFloat Adapt_scaleL(CGFloat level);

/*!
 @brief  竖直比例适配 取值为水平比例适配
 @param level 原值
 @return 适配后的值
 */
CGFloat Adapt_scaleV(CGFloat vertical);

/** 适配CGpoint */
CGPoint CGPointMakeAdapt(CGFloat x, CGFloat y);

/** 适配CGSize */
CGSize CGSizeMakeAdapt(CGFloat width, CGFloat height);

/** 适配CGRect */
CGRect CGRectMakeAdapt(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

/** 适配UIEdgeInsets */
UIEdgeInsets UIEdgeInsetsMakeAdapt(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

#pragma mark - 选择适配方式

#pragma mark 设计图为IPHONE4

CGFloat Adapt_IPHONE4_scaleL(CGFloat level);

CGFloat Adapt_IPHONE4_scaleV(CGFloat vertical);

CGPoint CGPointMakeIPHONE4Adapt(CGFloat x, CGFloat y);

CGSize  CGSizeMakeIPHONE4Adapt(CGFloat width, CGFloat height);

CGRect  CGRectMakeIPHONE4Adapt(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

UIEdgeInsets UIEdgeInsetsMakeIPHONE4Adapt(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

#pragma mark 设计图为IPHONE5/5s

CGFloat Adapt_IPHONE5_scaleL(CGFloat level);

CGFloat Adapt_IPHONE5_scaleV(CGFloat vertical);

CGPoint CGPointMakeIPHONE5Adapt(CGFloat x, CGFloat y);

CGSize  CGSizeMakeIPHONE5Adapt(CGFloat width, CGFloat height);

CGRect  CGRectMakeIPHONE5Adapt(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

UIEdgeInsets UIEdgeInsetsMakeIPHONE5Adapt(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

#pragma mark 设计图为IPHONE6

CGFloat Adapt_IPHONE6_scaleL(CGFloat level);

CGFloat Adapt_IPHONE6_scaleV(CGFloat vertical);

CGPoint CGPointMakeIPHONE6Adapt(CGFloat x, CGFloat y);

CGSize  CGSizeMakeIPHONE6Adapt(CGFloat width, CGFloat height);

CGRect  CGRectMakeIPHONE6Adapt(CGFloat x, CGFloat y,CGFloat width, CGFloat height);

UIEdgeInsets UIEdgeInsetsMakeIPHONE6Adapt(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);

#pragma mark 设计图为IPHONE6P

CGFloat Adapt_IPHONE6P_scaleL(CGFloat level);

CGFloat Adapt_IPHONE6P_scaleV(CGFloat vertical);

CGPoint CGPointMakeIPHONE6PAdapt(CGFloat x, CGFloat y);

CGSize  CGSizeMakeIPHONE6PAdapt(CGFloat width, CGFloat height);

CGRect  CGRectMakeIPHONE6PAdapt(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

UIEdgeInsets UIEdgeInsetsMakeIPHONE6PAdapt(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);


NSString* test();
@end