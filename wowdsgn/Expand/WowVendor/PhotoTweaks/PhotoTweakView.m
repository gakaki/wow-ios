//
//  PhotoView.m
//  PhotoTweaks
//
//  Created by Tu You on 14/12/2.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "PhotoTweakView.h"
#import "UIColor+Tweak.h"
#import "UIView+Extension.h"
#import <math.h>
#import "UIButton+ImageTitleStyle.h"

#define CX_W ([UIScreen mainScreen].bounds.size.width)
#define CX_H ([UIScreen mainScreen].bounds.size.height)
const CGFloat kMaxRotationAngle = 0.5;
static const NSUInteger kCropLines = 2;


static const CGFloat kMaximumCanvasWidthRatio = 1;

static const CGFloat kCropViewCornerLength = 22;

static const float singDegree = 1.0; // 一个刻度代表多少度
static const int minDegree = -45; //  最小刻度
static const int maxDegree = 45; // 最大刻度



//#define kInstruction

@implementation PhotoContentView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end

@interface PhotoScrollView : UIScrollView

@property (nonatomic, strong) PhotoContentView *photoContentView;

@end

@implementation PhotoScrollView

- (void)setContentOffsetY:(CGFloat)offsetY
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetY;
    self.contentOffset = contentOffset;
}

- (void)setContentOffsetX:(CGFloat)offsetX
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = offsetX;
    self.contentOffset = contentOffset;
}

- (CGFloat)zoomScaleToBound
{
    CGFloat scaleW = self.bounds.size.width / self.photoContentView.bounds.size.width;
    CGFloat scaleH = self.bounds.size.height / self.photoContentView.bounds.size.height;
    CGFloat max = MAX(scaleW, scaleH);
    
    return max;
}

@end

typedef NS_ENUM(NSInteger, CropCornerType) {
    CropCornerTypeUpperLeft,
    CropCornerTypeUpperRight,
    CropCornerTypeLowerRight,
    CropCornerTypeLowerLeft
};

@interface CropCornerView : UIView

@end

@implementation CropCornerView

- (instancetype)initWithCornerType:(CropCornerType)type
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kCropViewCornerLength, kCropViewCornerLength);
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat lineWidth = 2;
        UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCropViewCornerLength, lineWidth)];
        horizontal.backgroundColor = [UIColor cropLineColor];
        [self addSubview:horizontal];
        
        UIView *vertical = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, kCropViewCornerLength)];
        vertical.backgroundColor = [UIColor cropLineColor];
        [self addSubview:vertical];
        
        if (type == CropCornerTypeUpperLeft) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
            vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeUpperRight) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
            vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeLowerRight) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
            vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
        } else if (type == CropCornerTypeLowerLeft) {
            horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
            vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
        }
    }
    return self;
}

@end

@interface CropView ()

@property (nonatomic, strong) CropCornerView *upperLeft;
@property (nonatomic, strong) CropCornerView *upperRight;
@property (nonatomic, strong) CropCornerView *lowerRight;
@property (nonatomic, strong) CropCornerView *lowerLeft;

@property (nonatomic, strong) NSMutableArray *horizontalCropLines;
@property (nonatomic, strong) NSMutableArray *verticalCropLines;

@property (nonatomic, strong) NSMutableArray *horizontalGridLines;
@property (nonatomic, strong) NSMutableArray *verticalGridLines;



@property (nonatomic, weak) id<CropViewDelegate> delegate;

@property (nonatomic, assign) BOOL cropLinesDismissed;
@property (nonatomic, assign) BOOL gridLinesDismissed;

@end

@implementation CropView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor cropLineColor].CGColor;
        self.layer.borderWidth = 1;
        
        _horizontalCropLines = [NSMutableArray array];
        for (int i = 0; i < kCropLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor cropLineColor];
            [_horizontalCropLines addObject:line];
            [self addSubview:line];
        }
        
        _verticalCropLines = [NSMutableArray array];
        for (int i = 0; i < kCropLines; i++) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor cropLineColor];
            [_verticalCropLines addObject:line];
            [self addSubview:line];
        }
        
        
        _gridLinesDismissed = YES;
        ////// 四个角的边框
//        _upperLeft = [[CropCornerView alloc] initWithCornerType:CropCornerTypeUpperLeft];
//        _upperLeft.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength / 2);
//        _upperLeft.autoresizingMask = UIViewAutoresizingNone;
//        [self addSubview:_upperLeft];
//        
//        _upperRight = [[CropCornerView alloc] initWithCornerType:CropCornerTypeUpperRight];
//        _upperRight.center = CGPointMake(self.frame.size.width - kCropViewCornerLength / 2, kCropViewCornerLength / 2);
//        _upperRight.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [self addSubview:_upperRight];
//        
//        _lowerRight = [[CropCornerView alloc] initWithCornerType:CropCornerTypeLowerRight];
//        _lowerRight.center = CGPointMake(self.frame.size.width - kCropViewCornerLength / 2, self.frame.size.height - kCropViewCornerLength / 2);
//        _lowerRight.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//        [self addSubview:_lowerRight];
//        
//        _lowerLeft = [[CropCornerView alloc] initWithCornerType:CropCornerTypeLowerLeft];
//        _lowerLeft.center = CGPointMake(kCropViewCornerLength / 2, self.frame.size.height - kCropViewCornerLength / 2);
//        _lowerLeft.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//        [self addSubview:_lowerLeft];
        [self showCropLines];
    }
    return self;
}


- (void)updateCropLines:(BOOL)animate
{
    // show crop lines
    //    if (self.cropLinesDismissed) {
    [self showCropLines];
    //    }
    
    void (^animationBlock)(void) = ^(void) {
        [self updateLines:self.horizontalCropLines horizontal:YES];
        [self updateLines:self.verticalCropLines horizontal:NO];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:animationBlock];
    } else {
        animationBlock();
    }
}
// slider 改变时 ，增加的格子  比九宫格多的那种
- (void)updateGridLines:(BOOL)animate
{
    // show grid lines
    if (self.gridLinesDismissed) {
        [self showGridLines];
    }
    
    void (^animationBlock)(void) = ^(void) {
        
        [self updateLines:self.horizontalGridLines horizontal:YES];
        //        [self updateLines:self.verticalGridLines horizontal:NO];
    };
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)updateLines:(NSArray *)lines horizontal:(BOOL)horizontal
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *line = (UIView *)obj;
        if (horizontal) {
            line.frame = CGRectMake(0,
                                    (self.frame.size.height / (lines.count + 1)) * (idx + 1),
                                    self.frame.size.width,
                                    1 / [UIScreen mainScreen].scale);
        } else {
            line.frame = CGRectMake((self.frame.size.width / (lines.count + 1)) * (idx + 1),
                                    0,
                                    1 / [UIScreen mainScreen].scale,
                                    self.frame.size.height);
        }
    }];
}

- (void)dismissCropLines
{
    [UIView animateWithDuration:0.2 animations:^{
        [self dismissLines:self.horizontalCropLines];
        [self dismissLines:self.verticalCropLines];
    } completion:^(BOOL finished) {
        //        self.cropLinesDismissed = YES;
    }];
}

- (void)dismissGridLines
{
    [UIView animateWithDuration:0.2 animations:^{
        [self dismissLines:self.horizontalGridLines];
        //        [self dismissLines:self.verticalGridLines];
    } completion:^(BOOL finished) {
        self.gridLinesDismissed = YES;
    }];
}

- (void)dismissLines:(NSArray *)lines
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).alpha = 0.0f;
    }];
}

- (void)showCropLines
{
    //    self.cropLinesDismissed = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self showLines:self.horizontalCropLines];
        [self showLines:self.verticalCropLines];
    }];
}

- (void)showGridLines
{
    self.gridLinesDismissed = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self showLines:self.horizontalGridLines];
        //        [self showLines:self.verticalGridLines];
    }];
}

- (void)showLines:(NSArray *)lines
{
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).alpha = 1.0f;
    }];
}

@end

@interface PhotoTweakView () <UIScrollViewDelegate, CropViewDelegate>

@property (nonatomic, strong) PhotoScrollView *scrollView;
@property (nonatomic, strong) CropView *cropView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIScrollView *scrollViewAngle;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomBtnsView;
@property (nonatomic, strong) UIButton *oneBtn;
@property (nonatomic, strong) UIButton *twoBtn;
@property (nonatomic, strong) UIButton *threeBtn;

@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign)   float changeDegree; // scrollView 移动1px对应的改变角度
@property (nonatomic, assign) BOOL manualZoomed; // 手动缩放
@property (nonatomic, strong) NSMutableArray *proportionBtns;
@property (nonatomic, strong) UIButton *cropBtn;
@property (nonatomic, strong) UIButton *rotaBtn;
// masks
@property (nonatomic, strong) UIView *topMask;
@property (nonatomic, strong) UIView *leftMask;
@property (nonatomic, strong) UIView *bottomMask;
@property (nonatomic, strong) UIView *rightMask;
@property (nonatomic, strong) UIView *centerView; // 中间指示条
@property (nonatomic, strong) UIImageView *scaleMaskView; // 透明蒙版
// constants
@property (nonatomic, assign) CGSize maximumCanvasSize;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGFloat maxRotationAngle;

@end

@implementation PhotoTweakView

- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
             maxRotationAngle:(CGFloat)maxRotationAngle
{
    if (self = [super init]) {
        
        self.frame = frame;
        
        _image = image;
        _isCrop = YES; // 默认不裁剪
        _isRoat = YES; // 默认不旋转
        _maxRotationAngle = maxRotationAngle;
        
        // scale the image 画布大小
        _maximumCanvasSize = CGSizeMake(kMaximumCanvasWidthRatio * self.frame.size.width,
                                        kMaximumCanvasWidthRatio * self.frame.size.width);
        
        CGFloat scaleX = image.size.width / self.maximumCanvasSize.width;
        CGFloat scaleY = image.size.height / self.maximumCanvasSize.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, image.size.width / scale, image.size.height / scale);
        _originalSize = bounds.size;
        
        _centerY = self.maximumCanvasSize.height / 2 + 10;
        
        _scrollView = [[PhotoScrollView alloc] initWithFrame:bounds];
        _scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        //        _scrollView.bounces = YES;
        //        _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;// 最小缩放
        _scrollView.maximumZoomScale = 3;// 最大缩放
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
        
        _scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self addSubview:_scrollView];
#ifdef kInstruction
        _scrollView.layer.borderColor = [UIColor redColor].CGColor;
        _scrollView.layer.borderWidth = 1;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
#endif
        
        _photoContentView = [[PhotoContentView alloc] initWithImage:image];// 存放 image 的View
        _photoContentView.frame = self.scrollView.bounds;
        //        _photoContentView.center = self.scrollView.center;
        //        _photoContentView.backgroundColor = [UIColor blueColor];
        _photoContentView.userInteractionEnabled = YES;
        _scrollView.photoContentView = self.photoContentView;
        [self.scrollView addSubview:_photoContentView];
        
        _cropView = [[CropView alloc] initWithFrame:self.scrollView.frame]; // 裁剪图形的View
        _cropView.center = self.scrollView.center;
        _cropView.delegate = self;
        [self addSubview:_cropView];
        
        UIColor *maskColor = [UIColor maskColor]; // 裁剪边框上下左右的背景颜色
        _topMask = [UIView new];
        _topMask.backgroundColor = maskColor;
        [self addSubview:_topMask];
        _leftMask = [UIView new];
        _leftMask.backgroundColor = maskColor;
        [self addSubview:_leftMask];
        _bottomMask = [UIView new];
        _bottomMask.backgroundColor = maskColor;
        [self addSubview:_bottomMask];
        _rightMask = [UIView new];
        _rightMask.backgroundColor = maskColor;
        [self addSubview:_rightMask];
        [self updateMasks:NO];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.mj_h - 395)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _centerY + (CX_W / 2) + (_bottomView.mj_h / 2) + 10 );
        [self addSubview:_bottomView];
        
        _cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cropBtn.frame = CGRectMake(30, 20, 30, 30);
        _cropBtn.center =  CGPointMake(CX_W / 2 + 35, 35);
        
        
        [_cropBtn addTarget:self action:@selector(cropBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_cropBtn setImage:[UIImage imageNamed:@"crop-no"] forState:UIControlStateNormal];
        [_cropBtn setImage:[UIImage imageNamed:@"crop-yes"] forState:UIControlStateSelected];
        [_bottomView addSubview:_cropBtn];
        
        _rotaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotaBtn.frame = CGRectMake(_cropBtn.mj_x + _cropBtn.mj_w + 40, 20, 30, 30);
        _rotaBtn.center = CGPointMake(CX_W / 2 - 35, 35);
        
        [_rotaBtn addTarget:self action:@selector(rotaBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_rotaBtn setImage:[UIImage imageNamed:@"rotating-no"] forState:UIControlStateNormal];
        [_rotaBtn setImage:[UIImage imageNamed:@"rotating-yes"] forState:UIControlStateSelected];
        _rotaBtn.selected = YES;
        [_bottomView addSubview:_rotaBtn];
        
        
        [self configAngleScrollView];
        
        [self configBottomBtns];
        
        
        
        _originalPoint = [self convertPoint:self.scrollView.center toView:self];
        [self configCropView:CGSizeMake(CX_W, CX_W)];
        self.sizeImgId = 1;
    }
    return self;
}
// 配置底部比例按钮
-(void)configBottomBtns{
    
    NSArray *btnTitleArray  = @[@"1:1",@"3:2",@"4:3",@"16:9"];
    NSArray *btnImgSelected = @[@"croponeone-selected",@"cropthreetwo-selected",@"cropfourthree-selected",@"cropnice-selected"];
    NSArray *btnImg         = @[@"croponeone",@"cropthreetwo",@"cropfourthree",@"cropnice"];
    _proportionBtns = [NSMutableArray array];
    
    _bottomBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CX_W, 100)];
    //    _bottomBtnsView.backgroundColor = [UIColor blueColor];
    
    _bottomBtnsView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _bottomView.mj_h - (_bottomBtnsView.mj_h / 2) - 5);
    //    _bottomBtnsView.backgroundColor = [UIColor cyanColor];
    [_bottomView addSubview:_bottomBtnsView];
    float btnBottom = 40;
    
    float centerPX = CX_W / 5 ;
    for (int i = 0; i < btnTitleArray.count; i++) {
        
        UIButton *sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        sizeBtn.backgroundColor = [UIColor redColor];
        sizeBtn.frame = CGRectMake(0, 0, 50, 50);
        sizeBtn.center = CGPointMake(centerPX + (i * centerPX) , _bottomBtnsView.mj_h/2 - btnBottom);
        
        
        [sizeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sizeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [sizeBtn setTitleColor:[UIColor resetButtonColor] forState:UIControlStateNormal];
        [sizeBtn setTitleColor:[UIColor resetButtonHighlightedColor] forState:UIControlStateSelected];
        [sizeBtn addTarget:self action:@selector(resetBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [sizeBtn setImage:[UIImage imageNamed:btnImg[i]] forState:UIControlStateNormal];
        [sizeBtn setImage:[UIImage imageNamed:btnImgSelected[i]] forState:UIControlStateSelected];
        
        
        [sizeBtn setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:5];
        
        // 加载按钮到视图
        sizeBtn.tag = i;
        if (i == 0) {
            [sizeBtn setSelected:YES];
        }
        [_proportionBtns addObject:sizeBtn];
        
        [_bottomBtnsView addSubview:sizeBtn];
        
    }
    _bottomBtnsView.hidden = YES;
}
// 配置滚动角度的scrollView
-(void)configAngleScrollView {
    float angleHeight = 50;
    float lineHeight  = 36;
    
    float scroollViewWidth = CX_W - 30;
    
    
    float allGrid = (maxDegree - minDegree)/singDegree;
    float gridWidth = scroollViewWidth / 20;
    float contentSizeX = gridWidth * allGrid;
    
    _changeDegree =  (maxDegree - minDegree) / contentSizeX;
    
    
    _scrollViewAngle = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CX_W - 30, angleHeight + 20)];
    _scrollViewAngle.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - 65);
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    //    _scrollViewAngle.backgroundColor = [UIColor greenColor];
    _scrollViewAngle.showsVerticalScrollIndicator = NO;
    _scrollViewAngle.showsHorizontalScrollIndicator = NO;
    _scrollViewAngle.tag =  10000;
    _scrollViewAngle.delegate = self;
    _scrollViewAngle.contentSize = CGSizeMake(contentSizeX + scroollViewWidth, 60);
    for (int i = 0; i <= allGrid; i++) {
        UIView *viewLine = [UIView new];
        viewLine.frame = CGRectMake(scroollViewWidth/2 + gridWidth*i, 0, 1, lineHeight);
        viewLine.backgroundColor = [UIColor darkGrayColor];
        viewLine.center = CGPointMake(viewLine.center.x, angleHeight / 2 );
        if (i%5 == 0) {
            UILabel *lbDegree = [UILabel new];
            
            
            lbDegree.frame = CGRectMake(0, 0, 45, 10);
            lbDegree.font = [UIFont systemFontOfSize:12];
            
            lbDegree.center = CGPointMake(viewLine.center.x, angleHeight + (lbDegree.mj_h / 2) + 5);
            lbDegree.textAlignment = NSTextAlignmentCenter;
            lbDegree.text = [NSString stringWithFormat:@"%i°",i - maxDegree];
            
            [_scrollViewAngle addSubview:lbDegree];
            
            viewLine.mj_h = angleHeight;
            
            viewLine.center = CGPointMake(viewLine.center.x, (angleHeight / 2) - (angleHeight -  lineHeight)/2 );
        }
        
        [_scrollViewAngle addSubview:viewLine];
        
    }
    // 指定到中间的位置
    [_scrollViewAngle setContentOffset:CGPointMake(((gridWidth * allGrid)/2) - 0.5, 0) animated:NO];
    [self addSubview:_scrollViewAngle];
    
    _scaleMaskView = [[UIImageView alloc] initWithFrame:_scrollViewAngle.frame];
    _scaleMaskView.image = [UIImage imageNamed:@"scaleMask"];
    [self addSubview:_scaleMaskView];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, _scrollViewAngle.mj_h - 10)];
    _centerView.backgroundColor = [UIColor centerLineColor];
    _centerView.center = CGPointMake(_scrollViewAngle.center.x, _scrollViewAngle.center.y - (_scrollViewAngle.mj_h - angleHeight));
    [self addSubview:_centerView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ( [scrollView tag] == 10000) {
        
        float zero =  scrollView.contentSize.width / 2; // 零度位置
        float x = scrollView.contentOffset.x + scrollView.mj_w/2; // scrollView滑动角度
        
        [self angelValueChanged:_changeDegree * (x - zero)]; // 旋转
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [self initWithFrame:frame image:image maxRotationAngle:kMaxRotationAngle];
}


// 事件传递 处理底部 scrollView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    
    if (CGRectContainsPoint(self.scrollView.frame, point)) {
        if (CGRectContainsPoint(self.bottomView.frame, point)){
            for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
                CGPoint convertedPoint = [subview convertPoint:point fromView:self];
                UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
                if (hitTestView) {
                    return hitTestView;
                }
            }
            
        }
        
        return self.scrollView;
        
    }else {//reverseObjectEnumerator 反序数组
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
        
    }
    
}
// scrollView 缩放  返回需要zoom的View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoContentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.manualZoomed = YES;
}

#pragma mark - Crop View Delegate

- (void)cropMoved:(CropView *)cropView
{
    [self updateMasks:NO];
}

- (void)cropEnded:(CropView *)cropView
{
    
    CGRect newCropBounds = CGRectMake(0, 0, cropView.frame.size.width, cropView.frame.size.height);
    
    // calculate the new bounds of scroll view
    CGFloat width = fabs(cos(self.angle)) * newCropBounds.size.width + fabs(sin(self.angle)) * newCropBounds.size.height;
    CGFloat height = fabs(sin(self.angle)) * newCropBounds.size.width + fabs(cos(self.angle)) * newCropBounds.size.height;
    
    // calculate the zoom area of scroll view
    CGRect scaleFrame = cropView.frame;
    if (scaleFrame.size.width >= self.scrollView.bounds.size.width) {
        scaleFrame.size.width = self.scrollView.bounds.size.width - 1;
    }
    if (scaleFrame.size.height >= self.scrollView.bounds.size.height) {
        scaleFrame.size.height = self.scrollView.bounds.size.height - 1;
    }
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width = width;
    bounds.size.height = height;
    self.scrollView.bounds = CGRectMake(0, 0, width, height);
    CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
    self.scrollView.contentOffset = newContentOffset;
    
    [UIView animateWithDuration:0.25 animations:^{ // 改变内部cropView的center
        
        cropView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        
        
    }];
    
    self.manualZoomed = YES;
    
    // update masks
    [self updateMasks:YES];
    
    [self.cropView dismissCropLines];
    
    CGFloat scaleH = self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
    CGFloat scaleW = self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
    __block CGFloat scaleM = MAX(scaleH, scaleW);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        if (scaleM > 1) {
        // 改变内部cotentView的frame 大小  根据返回的比例辩护
        scaleM = scaleM * self.scrollView.zoomScale;
        [self.scrollView setZoomScale:scaleM animated:YES];
        
        self.scrollView.minimumZoomScale = [self.scrollView zoomScaleToBound];
        
        self.manualZoomed = NO;
        //        }
        [UIView animateWithDuration:0.2 animations:^{
            [self checkScrollViewContentOffset];
        }];
    });
}

- (void)updateMasks:(BOOL)animate
{
    void (^animationBlock)(void) = ^(void) {
        self.topMask.frame = CGRectMake(0, 0, self.cropView.frame.origin.x + self.cropView.frame.size.width, self.cropView.frame.origin.y);
        self.leftMask.frame = CGRectMake(0, self.cropView.frame.origin.y, self.cropView.frame.origin.x, self.frame.size.height - self.cropView.frame.origin.y);
        self.bottomMask.frame = CGRectMake(self.cropView.frame.origin.x, self.cropView.frame.origin.y + self.cropView.frame.size.height, self.frame.size.width - self.cropView.frame.origin.x, self.frame.size.height - (self.cropView.frame.origin.y + self.cropView.frame.size.height));
        self.rightMask.frame = CGRectMake(self.cropView.frame.origin.x + self.cropView.frame.size.width, 0, self.frame.size.width - (self.cropView.frame.origin.x + self.cropView.frame.size.width), self.cropView.frame.origin.y + self.cropView.frame.size.height);
    };
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)checkScrollViewContentOffset
{
    self.scrollView.contentOffsetX = MAX(self.scrollView.contentOffset.x, 0);
    self.scrollView.contentOffsetY = MAX(self.scrollView.contentOffset.y, 0);
    
    if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height) {
        self.scrollView.contentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    }
    
    if (self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width) {
        self.scrollView.contentOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
}
- (void)clearScrollViewChanged{
    
    self.isRoat = YES;
    self.angle = 0;
    
    self.scrollView.transform = CGAffineTransformIdentity;
    self.scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
    self.scrollView.bounds = CGRectMake(0, 0, self.originalSize.width, self.originalSize.height);
    self.scrollView.minimumZoomScale = 1;
    [self.scrollView setZoomScale:1 animated:NO];
    
    self.cropView.frame = self.scrollView.frame;
    self.cropView.center = self.scrollView.center;
    [self updateMasks:NO];
    
    
}

- (void)angelValueChanged:(float)sender
{
//    if (sender < 0.04 && sender > -0.04) {
//        NSLog(@"%f 改变较小",sender);
//        [self clearScrollViewChanged];
//        return;
//    }
    _isRoat = NO; // 旋转
    // update masks
    [self updateMasks:NO];
    
    // update grids
    [self.cropView updateGridLines:NO];
    
    // rotate scroll view
    self.angle = sender/100;
    self.scrollView.transform = CGAffineTransformMakeRotation(self.angle);
    
    // position scroll view
    CGFloat width = fabs(cos(self.angle)) * self.cropView.frame.size.width + fabs(sin(self.angle)) * self.cropView.frame.size.height;
    CGFloat height = fabs(sin(self.angle)) * self.cropView.frame.size.width + fabs(cos(self.angle)) * self.cropView.frame.size.height;
    CGPoint center = self.scrollView.center;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
    self.scrollView.bounds = CGRectMake(0, 0, width, height);
    CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
    self.scrollView.contentOffset = newContentOffset;
    self.scrollView.center = center;
    
    // scale scroll view
    BOOL shouldScale = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1.0 || self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1.0;
    if (!self.manualZoomed || shouldScale) {
        [self.scrollView setZoomScale:[self.scrollView zoomScaleToBound] animated:NO];
        self.scrollView.minimumZoomScale = [self.scrollView zoomScaleToBound];
        
        self.manualZoomed = NO;
    }
    
    [self checkScrollViewContentOffset];
}

- (void)sliderTouchEnded:(id)sender
{
    [self.cropView dismissGridLines];
}
// 根据不同的size 定制不同的cropView
- (void)configCropView:(CGSize)size{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cropView.mj_size = size;
        self.cropView.center = self.scrollView.center;
        
        [self cropMoved:self.cropView];
        [self cropEnded:self.cropView];
        
        [self.cropView updateCropLines:NO];
        
    }];
    
}
-(void)cropBtnTapped:(UIButton *)sender{
    if (sender.selected == NO) {// 点击状态
        if (self.rotaBtn.selected == YES){
            [self.rotaBtn setSelected:NO];
        }
        [sender setSelected:YES];
        _centerView.hidden = YES;
        _scaleMaskView.hidden = YES;
        _bottomBtnsView.hidden = NO;
        _scrollViewAngle.hidden = YES;
        
        
        
    }
    
}
-(void)rotaBtnTapped:(UIButton *)sender{
    if (sender.selected == NO) {// 点击状态
        if (self.cropBtn.selected == YES){
            [self.cropBtn setSelected:NO];
        }
        [sender setSelected:YES];
        _centerView.hidden = NO;
        _scaleMaskView.hidden = NO;
        _bottomBtnsView.hidden = YES;
        _scrollViewAngle.hidden = NO;
        
    }
    
}
- (void)resetBtnTapped:(UIButton *)sender
{
    CGFloat width   = 0;
    CGFloat height  = 0;
    switch ([sender tag]) {
        case 0: // 1:1
            width = CX_W;
            height = width * 1;
            break;
        case 1:// 3:2
            width = CX_W;
            height = width * 0.67;
            break;
        case 2:// 4:3
            width = CX_W;
            height = width * 0.75 ;
            break;
        case 3:// 16:9
            width = CX_W;
            height = width * 0.56;
            break;
        case 4://原图
            width = self.originalSize.width;
            height = self.originalSize.height;
            break;
        default:
            break;
    }
    self.sizeImgId = [sender tag] + 1;
    _isCrop =  NO;

    [_proportionBtns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = (UIButton *)obj;
        
        if (btn.tag != [sender tag]) { // 取消其他按钮选中状态
            if (btn.selected == YES) {// 点击状态
                
                [btn setSelected:NO];
                
            }
        }else {// 改变本身按钮选中状态
            if (btn.selected == NO) {
                [btn setSelected:YES];
                [self configCropView:CGSizeMake(width, height)];
            }
//            else{// 取消的话 恢复原本状态
//                [btn setSelected:NO];
//                _isCrop =  YES;
//                self.sizeImgId = 0;
//                [self configCropView:CGSizeMake(self.originalSize.width, self.originalSize.height)];
//            }
            
        }
    }];
    
}

- (CGPoint)photoTranslation
{
    CGRect rect = [self.photoContentView convertRect:self.photoContentView.bounds toView:self];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    CGPoint zeroPoint = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
    return CGPointMake(point.x - zeroPoint.x, point.y - zeroPoint.y);
}

@end
