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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];


    self.navigationController.navigationBar.translucent = NO;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.title = @"编辑图片";

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnTapped)];
    
    UIButton *regihtbutton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,60,30)];
    
    [regihtbutton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [regihtbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    regihtbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [regihtbutton addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regihtbutton];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor photoTweakCanvasBackgroundColor];

    [self setupSubviews];
}
- (void)setupSubviews
{
    self.photoView = [[PhotoTweakView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) image:self.image maxRotationAngle:self.maxRotationAngle];
//    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.photoView];
    

}

- (void)cancelBtnTapped
{
     self.navigationController.navigationBar.translucent = YES;
    [self.delegate photoTweaksControllerDidCancel:self];
}

- (void)saveBtnTapped
{
//    if (self.photoView.isCrop && self.photoView.isRoat) {
//        
//        [self.delegate photoTweaksController:self didFinishWithCroppedImage:self.image clooseSizeImgId:self.photoView.sizeImgId];
//        return;
//    }
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

    [self.delegate photoTweaksController:self didFinishWithCroppedImage:image clooseSizeImgId:self.photoView.sizeImgId];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
