//
//  KKCameraImageShowItemView.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageShowItemView.h"
#import "KKCategory.h"

@interface KKCameraImageShowItemView ()

@property (nonatomic , assign) CGRect myImageViewOriginFrame;
@property (nonatomic,strong) UIImageView *myImageView;

@end

@implementation KKCameraImageShowItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Notification_KKCameraImageShowItemViewResetZoomScale:) name:@"NotificationName_KKCameraImageShowItemViewResetZoomScale" object:nil];        
    }
    return self;
}

//单击
-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowItemViewSingleTap:)]) {
        [self.delegate KKCameraImageShowItemViewSingleTap:self];
    }
}

- (void)Notification_KKCameraImageShowItemViewResetZoomScale:(NSNotification*)notice{
    
    NSInteger index = [notice.object integerValue];
    if (index!=self.row) {
        [self.myScrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)setImage:(UIImage*)aImage{
    self.myImageView.image = aImage;
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
