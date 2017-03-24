//
//  PhotoTweaksViewController.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/5.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweaksViewController.h"
#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define DV_W ([UIScreen mainScreen].bounds.size.width)
#define DV_H ([UIScreen mainScreen].bounds.size.height)
@interface PhotoTweaksViewController ()

@property (strong, nonatomic) PhotoTweakView *photoView;

@end

@implementation PhotoTweaksViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        _autoSaveToLibray = YES;
        _maxRotationAngle = kMaxRotationAngle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.navigationController.navigationBarHidden = YES;

//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    self.title = @"编辑图片";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,60,30)];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [button addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *regihtbutton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,60,30)];
    
    [regihtbutton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [regihtbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    regihtbutton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [regihtbutton addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regihtbutton];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];

    [self setupSubviews];
}
- (void)configTopView{
    
//    UIView *viewTop = [UIView new];
//    viewTop.frame = CGRectMake(0, 0, DV_W, 64);
//    viewTop.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:viewTop];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 60, 64);
//    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    [viewTop addSubview:backBtn];
//    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextBtn.frame = CGRectMake(DV_W - 60, 0, 60, 64);
//    nextBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [nextBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    [viewTop addSubview:nextBtn];
//    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(DV_W/2, 0, 100, 64)];
//    lbTitle.textColor = [UIColor blackColor];
//    lbTitle.textAlignment = NSTextAlignmentCenter;
//    lbTitle.text = @"编辑图片";
//    [viewTop addSubview:lbTitle];
    
    
}
- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) image:self.image maxRotationAngle:self.maxRotationAngle];
//    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.photoView];
    
//    [self configTopView];
    
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(8, CGRectGetHeight(self.view.frame) - 40, 60, 40);
//    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @"PhotoTweaks", nil) forState:UIControlStateNormal];
//    UIColor *cancelTitleColor = !self.cancelButtonTitleColor ?
//    [UIColor cancelButtonColor] : self.cancelButtonTitleColor;
//    [cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
//    UIColor *cancelHighlightTitleColor = !self.cancelButtonHighlightTitleColor ?
//    [UIColor cancelButtonHighlightedColor] : self.cancelButtonHighlightTitleColor;
//    [cancelBtn setTitleColor:cancelHighlightTitleColor forState:UIControlStateHighlighted];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [cancelBtn addTarget:self action:@selector(cancelBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cancelBtn];
//    
//    UIButton *cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cropBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    cropBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60, CGRectGetHeight(self.view.frame) - 40, 60, 40);
//    [cropBtn setTitle:NSLocalizedStringFromTable(@"Done", @"PhotoTweaks", nil) forState:UIControlStateNormal];
//    UIColor *saveButtonTitleColor = !self.saveButtonTitleColor ?
//    [UIColor saveButtonColor] : self.saveButtonTitleColor;
//    [cropBtn setTitleColor:saveButtonTitleColor forState:UIControlStateNormal];
//    
//    UIColor *saveButtonHighlightTitleColor = !self.saveButtonHighlightTitleColor ?
//    [UIColor saveButtonHighlightedColor] : self.saveButtonHighlightTitleColor;
//    [cropBtn setTitleColor:saveButtonHighlightTitleColor forState:UIControlStateHighlighted];
//    cropBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [cropBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:cropBtn];
}

- (void)cancelBtnTapped
{
    [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)saveBtnTapped
{
    CGAffineTransform transform = CGAffineTransformIdentity;

    // translate
    CGPoint translation = [self.photoView photoTranslation];
    transform = CGAffineTransformTranslate(transform, translation.x, translation.y);

    // rotate
    transform = CGAffineTransformRotate(transform, self.photoView.angle);

    // scale
    CGAffineTransform t = self.photoView.photoContentView.transform;
    CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    transform = CGAffineTransformScale(transform, xScale, yScale);

    CGImageRef imageRef = [self newTransformedImage:transform
                                        sourceImage:self.image.CGImage
                                         sourceSize:self.image.size
                                  sourceOrientation:self.image.imageOrientation
                                        outputWidth:self.image.size.width
                                           cropSize:self.photoView.cropView.frame.size
                                      imageViewSize:self.photoView.photoContentView.bounds.size];

    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    if (self.autoSaveToLibray) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
            }
        }];
    }

    [self.delegate photoTweaksController:self didFinishWithCroppedImage:image];
}

- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;

    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 rgbColorSpace,//CGImageGetColorSpace(source),
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big//(CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );
    CGColorSpaceRelease(rgbColorSpace);

    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);

    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];

    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);

    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));

    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                            outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);

    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       , source);

    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
