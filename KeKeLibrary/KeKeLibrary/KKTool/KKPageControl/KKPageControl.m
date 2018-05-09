//
//  KKPageControl.m
//  ProjectK
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2015年 Beartech. All rights reserved.
//

#import "KKPageControl.h"
#import "UIView+KKCategory.h"
#import "UIButton+KKCategory.h"


@interface KKPageControl (){
    NSInteger _numberOfPages;
    NSInteger _currentPage;
    BOOL _hidesForSinglePage;
    CGFloat _pointSeparateSpace;
    KKPageControlAlignment _pointAlignment;
}

@property(nonatomic,retain)UIImage* activeImage;
@property(nonatomic,retain)UIImage* inactiveImage;

@property(nonatomic,retain)UIColor* activeColor;
@property(nonatomic,retain)UIColor* inactiveColor;
@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL selector;
@property(nonatomic,assign)UIControlEvents controlEvents;

@end

@implementation KKPageControl
@synthesize activeImage,inactiveImage;
@synthesize activeColor,inactiveColor;
@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize pointSeparateSpace = _pointSeparateSpace;
@synthesize target,selector,controlEvents;
@synthesize alignment=_pointAlignment;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        activeColor = [UIColor redColor];
        inactiveColor = [UIColor whiteColor];
        _pointSeparateSpace = 5.0;
        _hidesForSinglePage = YES;
        _pointAlignment = KKPageControlAlignmentCenter;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        activeColor = [UIColor redColor];
        inactiveColor = [UIColor whiteColor];
        _pointSeparateSpace = 5.0;
        _hidesForSinglePage = YES;
        _pointAlignment = KKPageControlAlignmentCenter;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame activeImage:(UIImage*)aActiveImage inactiveImage:(UIImage*)aInactiveImage{
    self = [super initWithFrame:frame];
    if (self) {
        activeImage = aActiveImage;
        inactiveImage = aInactiveImage;
        _pointSeparateSpace = 5.0;
        _hidesForSinglePage = YES;
        _pointAlignment = KKPageControlAlignmentCenter;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame activeColor:(UIColor*)aActiveColor inactiveColor:(UIColor*)aInactiveColor{
    self = [super initWithFrame:frame];
    if (self) {
        activeColor = aActiveColor;
        inactiveColor = aInactiveColor;
        _pointSeparateSpace = 5.0;
        _hidesForSinglePage = YES;
        _pointAlignment = KKPageControlAlignmentCenter;
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    if (numberOfPages==_numberOfPages) {
        return;
    }
    else{
        _numberOfPages = numberOfPages;
        [self reloadSubViews];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    if (currentPage==_currentPage) {
        return;
    }
    else{
        _currentPage = currentPage;
        [self reloadSubViews];
    }
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage{
    if (hidesForSinglePage==_hidesForSinglePage) {
        return;
    }
    else{
        _hidesForSinglePage = hidesForSinglePage;
        [self reloadSubViews];
    }
}

- (void)setAlignment:(KKPageControlAlignment)alignment{
    if (alignment==_pointAlignment) {
        return;
    }
    else{
        _pointAlignment = alignment;
        [self reloadSubViews];
    }
}


- (void)reloadSubViews{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    if (_numberOfPages==0) {
        return;
    }
    
    if (_numberOfPages==1 && _hidesForSinglePage==YES) {
        return;
    }
    
    CGSize activeSize;
    if (activeImage) {
        activeSize = activeImage.size;
    }
    else{
        activeSize = CGSizeMake(7, 7);
    }
    
    CGSize inactiveSize;
    if (inactiveImage) {
        inactiveSize = inactiveImage.size;
    }
    else{
        inactiveSize = CGSizeMake(7, 7);
    }

    CGFloat X = 0;
    if (_pointAlignment==KKPageControlAlignmentLeft) {
        X = 15;
    }
    else if (_pointAlignment==KKPageControlAlignmentCenter){
        X = (self.frame.size.width - _pointSeparateSpace*(MAX(_numberOfPages-1, 0)) - inactiveSize.width*(MAX(_numberOfPages-1, 0)) - activeSize.width)/2.0;
    }
    else{
        X = self.frame.size.width - _pointSeparateSpace*(MAX(_numberOfPages-1, 0)) - inactiveSize.width*(MAX(_numberOfPages-1, 0)) - activeSize.width-15;
    }

    
    for (NSInteger i=0; i<_numberOfPages; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.exclusiveTouch = YES;
        button.tag = i + 1101;
        if (i==_currentPage) {
            button.frame = CGRectMake(X, (self.frame.size.height-activeSize.height)/2.0, activeSize.width, activeSize.height);
            if (activeImage) {
                [button setBackgroundImage:activeImage forState:UIControlStateNormal];
            }
            else{
                [button setCornerRadius:button.frame.size.width/2.0];
                [button setBackgroundColor:activeColor forState:UIControlStateNormal];
            }
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(pointClicked:) forControlEvents:controlEvents];
            [self addSubview:button];
            button = nil;
            
            X = X + activeSize.width + _pointSeparateSpace;
        }
        else{
            button.frame = CGRectMake(X, (self.frame.size.height-inactiveSize.height)/2.0, inactiveSize.width, inactiveSize.height);
            if (inactiveImage) {
                [button setBackgroundImage:inactiveImage forState:UIControlStateNormal];
            }
            else{
                [button setCornerRadius:button.frame.size.width/2.0];
                [button setBackgroundColor:inactiveColor forState:UIControlStateNormal];
            }
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(pointClicked:) forControlEvents:controlEvents];
            [self addSubview:button];
            button = nil;
            
            X = X + inactiveSize.width + _pointSeparateSpace;
        }
    }
}

- (void)pointClicked:(UIButton*)pointButton{
    NSInteger index = pointButton.tag - 1101;
    if (index==_currentPage) {
        return;
    }
    _currentPage = pointButton.tag - 1101;
    [self reloadSubViews];
    if (target && selector && [target respondsToSelector:selector]) {
        [target performSelector:selector withObject:self afterDelay:0];
    }
}

- (void)addTarget:(id)aTarget action:(SEL)aAction forControlEvents:(UIControlEvents)aControlEvents{
    target = aTarget;
    selector = aAction;
    controlEvents = aControlEvents;
    [self reloadSubViews];
}

@end
