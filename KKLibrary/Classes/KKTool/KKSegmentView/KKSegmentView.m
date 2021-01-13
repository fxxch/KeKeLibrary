//
//  KKSegmentView.m
//  CEDongLi
//
//  Created by liubo on 16/1/1.
//  Copyright (c) 2016年 KeKeStudio. All rights reserved.
//

#import "KKSegmentView.h"
#import "UIView+KKCategory.h"
#import "UIColor+KKCategory.h"
#import "NSArray+KKCategory.h"
#import "KKButton.h"
#import "KKLibraryDefine.h"

#define KKSeg_MaskViewWidth (50.0f)

@interface KKSegmentView ()<UIScrollViewDelegate>{
    
    NSInteger _selectedIndex;
    
}

@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)NSMutableArray *buttonsArray;

@end

@implementation KKSegmentView
@synthesize selectedIndex = _selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = NSNotFound;
        self.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        self.buttonsArray = [[NSMutableArray alloc] init];
        
        [self initUI];
        
        [self reloadData];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.backgroundImageView clearBackgroundColor];
    [self addSubview:self.backgroundImageView];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self.mainScrollView clearBackgroundColor];
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    [self addSubview:self.mainScrollView];
    if (@available(iOS 11.0, *)) {
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0)];
    self.headLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
    [self addSubview:_headLineView];
    self.headLineView.hidden = YES;
    
    self.footLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1.0, self.frame.size.width, 1.0)];
    self.footLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
    [self addSubview:self.footLineView];
    self.footLineView.hidden = YES;
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2.0, 5, 2.0)];
    self.sliderView.backgroundColor = [UIColor blueColor];
    [self.mainScrollView addSubview:self.sliderView];
    self.sliderView.hidden = YES;
    
    self.leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKSeg_MaskViewWidth, self.frame.size.height)];
    self.leftMaskView.userInteractionEnabled = NO;
    [self.leftMaskView setBackgroundColorFromColor:[UIColor colorWithWhite:1.0 alpha:1.0] toColor:[UIColor colorWithWhite:1.0 alpha:0] direction:UIViewGradientColorDirection_LeftRight];
    [self addSubview:self.leftMaskView];
    self.leftMaskView.hidden = YES;
    
    self.rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-KKSeg_MaskViewWidth, 0, KKSeg_MaskViewWidth, self.frame.size.height)];
    self.rightMaskView.userInteractionEnabled = NO;
    [self.rightMaskView setBackgroundColorFromColor:[UIColor colorWithWhite:1.0 alpha:1.0] toColor:[UIColor colorWithWhite:1.0 alpha:0] direction:UIViewGradientColorDirection_RightLeft];
    [self addSubview:self.rightMaskView];
    self.rightMaskView.hidden = YES;
}

- (void)selectedIndex:(NSInteger)aIndex needRespondsDelegate:(BOOL)aNeedRespondsDelegate{
    
    if ([self.buttonsArray count]==0) {
        [self reloadData];
    }
    
    KKButton *button = (KKButton*)[self.buttonsArray objectAtIndex_Safe:aIndex];
    if (button) {
        [self buttonEvent:button needRespondsDelegate:aNeedRespondsDelegate];
    }
}

- (void)deselected_needRespondsDelegate:(BOOL)aNeedRespondsDelegate{
    
    if ([self.buttonsArray count]==0) {
        [self reloadData];
    }
    
    KKButton *oldButton = (KKButton*)[self.buttonsArray objectAtIndex_Safe:_selectedIndex];
    [oldButton setSelected:NO];
    
    if (self.delegate && aNeedRespondsDelegate &&
        [self.delegate respondsToSelector:@selector(KKSegmentView:willDeselectIndex:willSelectNewIndex:)]) {
        [self.delegate KKSegmentView:self
                   willDeselectIndex:_selectedIndex
                  willSelectNewIndex:NSNotFound];
    }
    
    _selectedIndex = NSNotFound;
}

- (KKButton*)buttonAtIndex:(NSInteger)aIndex{
    return [self.buttonsArray objectAtIndex_Safe:aIndex];
}

- (void)setDelegate:(id<KKSegmentViewDelegate>)delegate{
    _delegate = delegate;
    [self reloadData];
}

#pragma mark ==================================================
#pragma mark == 设置参数
#pragma mark ==================================================
- (void)setSliderSize:(CGSize)sliderSize{
    _sliderSize = sliderSize;
    [self reloadData];
}

#pragma mark ==================================================
#pragma mark == 刷新界面
#pragma mark ==================================================
- (void)reloadData{
    
    [self.buttonsArray removeAllObjects];
    for (UIView *subView in [self.mainScrollView subviews]) {
        if (subView==self.sliderView) {
            continue;
        }
        else{
            [subView removeFromSuperview];
        }
    }
    
    
    if (!self.delegate) {
        return;
    }
    
    NSInteger buttonsCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKSegmentView_NumberOfButtons:)]) {
        buttonsCount = [self.delegate KKSegmentView_NumberOfButtons:self];
    }
    
    CGFloat offsetX = 0 + self.leftMagin;
    for (NSInteger i=0; i<buttonsCount; i++) {
        
        KKButton *button = [self.delegate KKSegmentView:self buttonForIndex:i];
        button.frame = CGRectMake(offsetX, (self.mainScrollView.frame.size.height - button.frame.size.height)/2.0, button.frame.size.width, button.frame.size.height);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainScrollView addSubview:button];
        [button sendToBack];
        [self.buttonsArray addObject:button];
        offsetX = offsetX + button.frame.size.width;
        if (_selectedIndex==NSNotFound) {
//            if (i==0) {
//                button.selected = YES;
//            }
//            else{
//                button.selected = NO;
//            }
            button.selected = NO;
        }
        else{
            if (_selectedIndex==i) {
                button.selected = YES;
            }
            else{
                button.selected = NO;
            }
        }
    }
    
    self.mainScrollView.contentSize = CGSizeMake(MAX(offsetX, self.mainScrollView.frame.size.width), self.mainScrollView.frame.size.height);
}

#pragma mark ==================================================
#pragma mark == 界面与事件处理
#pragma mark ==================================================
- (void)buttonClicked:(KKButton*)aButton{
    [self buttonEvent:aButton needRespondsDelegate:YES];
}

- (void)buttonEvent:(KKButton*)aButton needRespondsDelegate:(BOOL)aNeedRespondsDelegate{
    
    NSInteger oldIndex = _selectedIndex;
    NSInteger newIndex = [self.buttonsArray indexOfObject:aButton];
    _selectedIndex = newIndex;
    
    KKButton *oldButton = [self.buttonsArray objectAtIndex_Safe:oldIndex];
    if (oldButton) {
        if (oldButton==aButton) {
            
            if (self.delegate && aNeedRespondsDelegate &&
                [self.delegate respondsToSelector:@selector(KKSegmentView:selectedSameIndex:)]) {
                [self.delegate KKSegmentView:self selectedSameIndex:newIndex];
            }
        }
        else{
            [oldButton setSelected:NO];
            [aButton setSelected:YES];
            
            [self buttonClicked_ReloadUIWithOldButton:oldButton newButton:aButton];
            
            if (self.delegate && aNeedRespondsDelegate &&
                [self.delegate respondsToSelector:@selector(KKSegmentView:willDeselectIndex:willSelectNewIndex:)]) {
                [self.delegate KKSegmentView:self
                           willDeselectIndex:oldIndex
                          willSelectNewIndex:newIndex];
            }
        }
    }
    else{
        [aButton setSelected:YES];
        
        [self buttonClicked_ReloadUIWithOldButton:oldButton newButton:aButton];
        
        if (self.delegate && aNeedRespondsDelegate &&
            [self.delegate respondsToSelector:@selector(KKSegmentView:willDeselectIndex:willSelectNewIndex:)]) {
            [self.delegate KKSegmentView:self
                       willDeselectIndex:oldIndex
                      willSelectNewIndex:newIndex];
        }
    }
}

- (void)buttonClicked_ReloadUIWithOldButton:(KKButton*)oldButton
                                  newButton:(KKButton*)newButton{
//    CGRect windowFrame = [newButton convertRect:newButton.bounds toView:[UIWindow currentKeyWindow]];

    NSInteger oldIndex = [self.buttonsArray indexOfObject:oldButton];
    NSInteger newIndex = [self.buttonsArray indexOfObject:newButton];
    CGFloat offset = 0;
    if (newIndex>oldIndex) {
        KKButton *readyButton = [self.buttonsArray objectAtIndex_Safe:newIndex+1];
        offset = readyButton.width/2.0;
    }
    else{
        KKButton *readyButton = [self.buttonsArray objectAtIndex_Safe:newIndex-1];
        offset = -readyButton.width/2.0;
    }
    
    CGFloat x = 0;

    CGFloat minX = self.mainScrollView.contentOffset.x;
    CGFloat maxX = self.mainScrollView.contentOffset.x+self.mainScrollView.frame.size.width;
    if (newButton.right+offset>=maxX) {
        KKButton *nextButton = [self.buttonsArray objectAtIndex_Safe:newIndex+1];
        if (nextButton) {
            x = MAX((nextButton.right-nextButton.width/2.0)-self.mainScrollView.width, 0);
            [self.mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
        else{
            x = MAX(self.mainScrollView.contentSize.width-self.frame.size.width, 0);
            [self.mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
    }
    else if (newButton.left+offset<=minX){
        KKButton *lastButton = [self.buttonsArray objectAtIndex_Safe:newIndex-1];
        if (lastButton) {
            CGFloat lastX = lastButton.right-lastButton.width/2.0;
            x = MAX(lastX, 0);
            [self.mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
        else{
            x = 0;
            [self.mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
    }
    else{
        x = self.mainScrollView.contentOffset.x;
        [self.mainScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }
    
    CGFloat sliderWidth = MIN(self.sliderSize.width, newButton.frame.size.width);
    if (sliderWidth<0.5) {
        sliderWidth = newButton.frame.size.width;
    }
    CGFloat sliderHeight = self.sliderSize.height;
    if (sliderHeight<0.5) {
        sliderHeight = 2.0;
    }
    KKWeakSelf(self)
    [UIView animateWithDuration:0.25 animations:^{
        weakself.sliderView.frame = CGRectMake((newButton.frame.origin.x+(newButton.frame.size.width-sliderWidth)/2.0), weakself.mainScrollView.frame.size.height-sliderHeight, sliderWidth, sliderHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<=KKSeg_MaskViewWidth) {
        _leftMaskView.alpha = 0;
    }
    else if (KKSeg_MaskViewWidth<scrollView.contentOffset.x && scrollView.contentOffset.x<scrollView.contentSize.width-scrollView.frame.size.width-KKSeg_MaskViewWidth){
        _leftMaskView.alpha = 1.0;
        _rightMaskView.alpha = 1.0;
    }
    else{
        _rightMaskView.alpha = 0;
    }
}




@end
