//
//  UMSAuthDetailViewController.m
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/10/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import "UMSAuthDetailViewController.h"
#import <UShareUI/UMSocialUIUtility.h>


@implementation UMSAuthInfo

+ (instancetype)objectWithType:(UMSocialPlatformType)platform
{
    UMSAuthInfo *obj = [UMSAuthInfo new];
    obj.platform = platform;
    UMSocialUserInfoResponse *resp = nil;
    
    NSDictionary *authDic = [[UMSocialDataManager defaultManager ] getAuthorUserInfoWithPlatform:platform];
    if (authDic) {
        resp = [[UMSocialUserInfoResponse alloc] init];
        resp.uid = [authDic objectForKey:kUMSocialAuthUID];
        resp.accessToken = [authDic objectForKey:kUMSocialAuthAccessToken];
        resp.expiration = [authDic objectForKey:kUMSocialAuthExpireDate];
        resp.refreshToken = [authDic objectForKey:kUMSocialAuthRefreshToken];
        resp.openid = [authDic objectForKey:kUMSocialAuthOpenID];
        
        obj.response = resp;
    }
    return obj;
}

@end


@interface UMSAuthDetailViewController ()

@property (nonatomic, strong) UIButton *cleanButton;
@property (nonatomic, strong) UIButton *duplicateButton;
@property (nonatomic, strong) UIButton *fetchButton;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation UMSAuthDetailViewController

+ (UMSAuthDetailViewController *)detailVCWithInfo:(UMSAuthInfo *)authInfo
{
    UMSAuthDetailViewController *VC = [[UMSAuthDetailViewController alloc] init];
    VC.authInfo = authInfo;
    return VC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *platformName = nil;
    NSString *iconName = nil;
    [UMSocialUIUtility configWithPlatformType:self.authInfo.platform withImageName:&iconName withPlatformName:&platformName];
    self.titleString = [NSString stringWithFormat:@"获取%@授权信息", platformName];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:13.f];
    _textView.backgroundColor = [UIColor colorWithRed:.83f green:.88f blue:.9f alpha:1.f];
    _textView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    [self.view addSubview:_textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.cleanButton = [self buttonWithName:@"清除信息"];
    _cleanButton.userInteractionEnabled = YES;
    [_cleanButton addTarget:self action:@selector(cleanData) forControlEvents:UIControlEventTouchUpInside];
    
    self.duplicateButton = [self buttonWithName:@"复制"];
    _duplicateButton.userInteractionEnabled = YES;
    [_duplicateButton addTarget:self action:@selector(copyData) forControlEvents:UIControlEventTouchUpInside];

    self.fetchButton = [self buttonWithName:@"获取信息"];
    _fetchButton.backgroundColor = [UIColor colorWithRed:0.f/255.f green:134.f/255.f blue:220.f/255.f alpha:1.f];
    [_fetchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fetchButton.userInteractionEnabled = YES;
    [_fetchButton addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_cleanButton];
    [self.view addSubview:_duplicateButton];
    [self.view addSubview:_fetchButton];
    
    [self refreshLayout];
    
    _textView.text = [self authInfoString:self.authInfo.response];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [self refreshLayout];
}

- (void)refreshLayout
{
    CGFloat pad = 10.f;
    CGFloat padY = [self viewOffsetY] + 10.f;
    CGRect frame = CGRectMake(pad, padY, 90.f, 28.f);
    _cleanButton.frame = frame;
    
    frame.origin.x += frame.size.width + pad;
    frame.size.width = 50.f;
    _duplicateButton.frame = frame;
    
    frame.size.width = 90.f;
    frame.origin.x = self.view.frame.size.width - frame.size.width - pad;
    _fetchButton.frame = frame;
    
    frame = self.view.bounds;
    frame.origin.x = pad;
    frame.size.width -= pad * 2;
    frame.origin.y = _fetchButton.frame.origin.y + _fetchButton.frame.size.height + pad;
    frame.size.height = self.view.bounds.size.height - frame.origin.y - pad;
    _textView.frame = frame;
    _textView.scrollEnabled = NO;
    _textView.scrollEnabled = YES;
}


#pragma mark -
- (void)cleanData
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:self.authInfo.platform completion:^(id result, NSError *error) {
    }];
    self.authInfo.response = nil;
    self.textView.text = nil;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除信息"
                                                    message:@"已清除"
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)copyData
{
    NSString *content = nil;
    if (_textView.text.length == 0) {
        content = @"没有复制内容";
    } else {
        content = @"已复制到剪贴板";
        [UIPasteboard generalPasteboard].string = _textView.text;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"复制"
                                                    message:content
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)fetchData
{
    __weak UMSAuthDetailViewController *ws = self;

    //6.1版本已经修正了getUserInfoWithPlatform，每次获得用户都需要跳转授权
    //如果不需要每次跳转，可以查看[UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo,来设置
    //[[UMSocialManager defaultManager] cancelAuthWithPlatform:self.authInfo.platform completion:^(id result, NSError *error) {
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:ws.authInfo.platform currentViewController:self completion:^(id result, NSError *error) {
            
            NSString *message = nil;
            
            if (error) {
                message = @"Get info fail";
                UMSocialLogInfo(@"Get info fail with error %@",error);
            }else{
                if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    
                    UMSocialUserInfoResponse *resp = result;
                    
                    ws.authInfo.response = resp;
                    
                    message = [ws authInfoString:resp];
                }else{
                    message = @"Get info fail";
                }
            }
            ws.textView.text = message;
        }];
    //}];
}

- (NSString *)authInfoString:(UMSocialUserInfoResponse *)resp
{
    NSMutableString *string = [NSMutableString new];
    if (resp.uid) {
        [string appendFormat:@"uid = %@\n", resp.uid];
    }
    if (resp.openid) {
        [string appendFormat:@"openid = %@\n", resp.openid];
    }
    if (resp.accessToken) {
        [string appendFormat:@"accessToken = %@\n", resp.accessToken];
    }
    if (resp.refreshToken) {
        [string appendFormat:@"refreshToken = %@\n", resp.refreshToken];
    }
    if (resp.expiration) {
        [string appendFormat:@"expiration = %@\n", resp.expiration];
    }
    if (resp.name) {
        [string appendFormat:@"name = %@\n", resp.name];
    }
    if (resp.iconurl) {
        [string appendFormat:@"iconurl = %@\n", resp.iconurl];
    }
    if (resp.gender) {
        [string appendFormat:@"gender = %@\n", resp.gender];
    }
    return string;
}

- (UIButton *)buttonWithName:(NSString *)name
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 100.f, 28.f);
    button.layer.borderColor = [UIColor colorWithRed:0.f green:0.53f blue:0.8f alpha:1.f].CGColor;
    button.layer.borderWidth = 1.f;
    button.layer.cornerRadius = 3.f;
    
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.f green:0.53f blue:0.86f alpha:1.f] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    return button;
}

@end
