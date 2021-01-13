//
//  KKWindowImageShowItemView.m
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKWindowImageShowItemView.h"
#import "UIButton+KKWebCache.h"
#import "UIImageView+KKWebCache.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KKCategory.h"

@interface KKWindowImageShowItemView ()

@property (nonatomic , assign) CGRect myImageViewOriginFrame;

@end

@implementation KKWindowImageShowItemView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 初始化界面
#pragma mark ==================================================
- (void)initUI{
    self.backgroundColor = [UIColor clearColor];

    self.myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myScrollView.bounces = YES;
    self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.myScrollView.minimumZoomScale = 1.0;
    self.myScrollView.maximumZoomScale = 5.0;
    self.myScrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.myImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myImageView.clipsToBounds = YES;
    self.myImageView.backgroundColor = [UIColor clearColor];
    self.myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self.myScrollView addSubview:self.myImageView];
    [self addSubview:self.myScrollView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.myScrollView addGestureRecognizer:tapGestureRecognizer];

    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressGesture.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    [longPressGesture setDelegate:self];
    [self.myScrollView addGestureRecognizer:longPressGesture];
}

- (void)reloaWithItem:(KKWindowImageItem*_Nonnull)aItem{
    self.itemInfo = aItem;

    //先设置占位图
    UIImage *placeImage = nil;
    if (self.itemInfo.inImage) {
        placeImage = self.itemInfo.inImage;
    }
    if (placeImage==nil) {
        placeImage = self.itemInfo.plachHolderImage;
    }
    if (placeImage) {
        self.myImageView.image = placeImage;
        [self initImageViewFrame];
    }
    else {
        if (self.itemInfo.inImageData) {
            [self showImageViewWithData:self.itemInfo.inImageData];
        } else {
            [self showImageViewWithData:nil];
        }
    }

    //加载大图
    if ([NSString isLocalFilePath:self.itemInfo.originImageURLString]) {
        NSURL *fileURL = [NSURL URLWithString:self.itemInfo.originImageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:fileURL];
        [self showImageViewWithData:imageData];
    }
    else {
        NSURL *iamgeURL = [NSURL URLWithString:self.itemInfo.originImageURLString];
        if (iamgeURL) {
            KKWeakSelf(self);
            [self.myImageView setImageWithURL:iamgeURL placeholderImage:placeImage showActivityStyle:KKActivityIndicatorViewStyleWhiteLarge completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {

                [weakself showImageViewWithData:imageData];
            }];
        }
    }
}

//单击
-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowItemViewSingleTap:)]) {
        [self.delegate KKWindowImageShowItemViewSingleTap:self];
    }
}

//长按
-(void) longPressed:(UITapGestureRecognizer*) tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowItemViewLongPressed:)]) {
            [self.delegate KKWindowImageShowItemViewLongPressed:self];
        }
    }
}

- (void)showImageViewWithData:(NSData*)imageData{
    self.currentIsGif = [[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF];
    [self.myImageView showImageData:imageData];
    [self initImageViewFrame];
}


#pragma mark ==================================================
#pragma mark == 缩放
#pragma mark ==================================================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.myImageView;//返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self reloadImageViewFrame];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [self reloadImageViewFrame];
//    NSLog(@"%@: SCALE:%.1f",view,scale);
}

- (void)reloadImageViewFrame{
    float imageWidth = self.myImageViewOriginFrame.size.width * self.myScrollView.zoomScale;
    float imageHeight = self.myImageViewOriginFrame.size.height * self.myScrollView.zoomScale;
    float newScrollWidth = MAX(self.myScrollView.contentSize.width, self.myScrollView.width);
    float newScrollHeight = MAX(self.myScrollView.contentSize.height, self.myScrollView.height);
    self.myImageView.frame = CGRectMake((newScrollWidth-imageWidth)/2.0, (newScrollHeight-imageHeight)/2.0, imageWidth, imageHeight);
//    NSLog(@"AAA scale:%.1f frame:%@",self.myScrollView.zoomScale,NSStringFromCGRect(self.myImageView.frame));
}

- (void)initImageViewFrame{
    if (self.myImageView.image) {
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
        
        float widthRatio = self.myScrollView.bounds.size.width / self.myImageView.image.size.width;
        float heightRatio = self.myScrollView.bounds.size.height / self.myImageView.image.size.height;
        float scale = MIN(widthRatio,heightRatio);
        float imageWidth = scale * self.myImageView.image.size.width * self.myScrollView.zoomScale;
        float imageHeight = scale * self.myImageView.image.size.height * self.myScrollView.zoomScale;
        self.myImageView.frame = CGRectMake((self.myScrollView.width-imageWidth)/2.0, (self.myScrollView.height-imageHeight)/2.0, imageWidth, imageHeight);
        self.myImageViewOriginFrame = self.myImageView.frame;
    } else {
        [self.myScrollView setZoomScale:1.0 animated:YES];;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 1.0;
        
        if ([NSArray isArrayNotEmpty:self.myImageView.animationImages]) {
            float widthRatio = self.myScrollView.bounds.size.width;
            float heightRatio = self.myScrollView.bounds.size.height;
            float scale = MIN(widthRatio,heightRatio);
            float imageWidth = scale * self.myImageView.bounds.size.width * self.myScrollView.zoomScale;
            float imageHeight = scale * self.myImageView.bounds.size.height * self.myScrollView.zoomScale;
            self.myImageView.frame = CGRectMake((self.myScrollView.width-imageWidth)/2.0, (self.myScrollView.height-imageHeight)/2.0, imageWidth, imageHeight);
            self.myImageViewOriginFrame = self.myImageView.frame;
        }
    }
}


@end
