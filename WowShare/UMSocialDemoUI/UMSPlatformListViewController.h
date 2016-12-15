//
//  UMSAuthViewController.h
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/8/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSBaeViewController.h>

typedef NS_ENUM(NSUInteger, UMSAuthViewType)
{
    UMSAuthViewTypeAuth,
    UMSAuthViewTypeUserInfo,
    UMSAuthViewTypeShare
};
@interface UMSPlatformListViewController : UMSBaeViewController

- (instancetype)initWithViewType:(UMSAuthViewType)type;

@end
