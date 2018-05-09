//
//  KKSegmentView.m
//  CEDongLi
//
//  Created by liubo on 16/1/1.
//  Copyright (c) 2016年 KeKeStudio. All rights reserved.
//

#import "KKSegmentView.h"
#import "KKButton.h"
#import "KKCategory.h"
#import "KeKeLibraryDefine.h"

#define MaskViewWidth (50.0f)

@interface KKSegmentView ()<UIScrollViewDelegate>{
    CGFloat      _widthPerSegment;
    UIImageView *_backgroundImageView;
    UIView      *_sliderView;
    UIView      *_headLineView;
    UIView      *_footLineView;
    UIView      *_leftMaskView;
    UIView      *_rightMaskView;
}

@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,assign)NSInteger segmentCount;

@end

@implementation KKSegmentView
@synthesize mainScrollView;
@synthesize segmentCount;
@synthesize selectedIndex;

@synthesize widthPerSegment = _widthPerSegment;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize sliderView = _sliderView;
@synthesize headLineView = _headLineView;
@synthesize footLineView = _footLineView;
@synthesize leftMaskView = _leftMaskView;
@synthesize rightMaskView = _rightMaskView;

@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame segmentCount:(NSInteger)aCount{
    return [self initWithFrame:frame segmentCount:aCount widthPerSegment:0];
}

- (instancetype)initWithFrame:(CGRect)frame segmentCount:(NSInteger)aCount widthPerSegment:(CGFloat)aWidthPerSegment{
    self = [super initWithFrame:frame];
    if (self) {
        _widthPerSegment = aWidthPerSegment;
        segmentCount = aCount;
        selectedIndex = NSNotFound;
        self.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    CGFloat width = KKApplicationWidth/segmentCount;
    if (_widthPerSegment>1) {
        width = _widthPerSegment;
    }

    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_backgroundImageView clearBackgroundColor];
    [self addSubview:_backgroundImageView];
    
    _headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0)];
    _headLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
    [self addSubview:_headLineView];

    _footLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1.0, self.frame.size.width, 1.0)];
    _footLineView.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
    [self addSubview:_footLineView];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [mainScrollView clearBackgroundColor];
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.delegate = self;
    [self addSubview:mainScrollView];
    
    _leftMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MaskViewWidth, self.frame.size.height-2)];
    _leftMaskView.userInteractionEnabled = NO;
    [_leftMaskView setBackgroundColorFromColor:[UIColor colorWithWhite:1.0 alpha:1.0] toColor:[UIColor colorWithWhite:1.0 alpha:0] direction:UIViewGradientColorDirection_LeftRight];
    [self addSubview:_leftMaskView];

    _rightMaskView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-MaskViewWidth, 0, MaskViewWidth, self.frame.size.height-2)];
    _rightMaskView.userInteractionEnabled = NO;
    [_rightMaskView setBackgroundColorFromColor:[UIColor colorWithWhite:1.0 alpha:1.0] toColor:[UIColor colorWithWhite:1.0 alpha:0] direction:UIViewGradientColorDirection_RightLeft];
    [self addSubview:_rightMaskView];

    for (NSInteger i=0; i<segmentCount; i++) {
        KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(i*width, 0, width, self.frame.size.height-1) type:KKButtonType_ImgLeftTitleRight_Center];
        button.spaceBetweenImgTitle = 0;
        button.imageViewSize = CGSizeMake(0, 0);
        button.edgeInsets = UIEdgeInsetsZero;
        button.textLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"哈哈" forState:UIControlStateNormal];
        [button clearBackgroundColor];
        button.tag = 9900+i;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mainScrollView addSubview:button];
        
        if (i==selectedIndex) {
            button.selected = YES;
        }
        
        mainScrollView.contentSize = CGSizeMake((i+1)*width, self.frame.size.height);
        
        if (i==0) {
            if (i==segmentCount-1) {
                
            }
            else{
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-0.5, 15, 0.5, self.frame.size.height-30)];
                line.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
                line.tag = 20161028;
                [button addSubview:line];
                
            }
        }
        else if (i==segmentCount-1){
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 0.5, self.frame.size.height-30)];
            line1.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
            line1.tag = 20161028;
            [button addSubview:line1];
            
        }
        else{
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 0.5, self.frame.size.height-30)];
            line1.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
            line1.tag = 20161028;
            [button addSubview:line1];
            
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-0.5, 15, 0.5, self.frame.size.height-30)];
            line2.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
            line2.tag = 20161029;
            [button addSubview:line2];
            
        }
    }
    
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2.0, width, 2.0)];
    _sliderView.backgroundColor = [UIColor blueColor];
    [mainScrollView addSubview:_sliderView];
}

- (void)hideAllSeperatorLine{
    NSArray *allButtons = [self allButtons];
    for (NSInteger i=0; i<[allButtons count]; i++) {
        KKButton *button = (KKButton*)[allButtons objectAtIndex:i];
        UIView *line = [button viewWithTag:20161028];
        line.hidden = YES;
        UIView *line2 = [button viewWithTag:20161029];
        line2.hidden = YES;
    }
}

- (void)buttonClicked:(KKButton*)aButton{
    KKButton *oldButton = (KKButton*)[mainScrollView viewWithTag:9900+selectedIndex];
    if (oldButton) {
        if (oldButton==aButton) {
            if (delegate && [delegate respondsToSelector:@selector(KKSegmentView:selectedSameIndex:)]) {
                [delegate KKSegmentView:self selectedSameIndex:selectedIndex];
            }
        }
        else{
            [oldButton setSelected:NO];
            [aButton setSelected:YES];
            
            CGRect windowFrame = [aButton convertRect:aButton.bounds toView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
            CGFloat maxX = windowFrame.origin.x+windowFrame.size.width;
            CGFloat x = 0;
            if (maxX<windowFrame.size.width) {
                x = MAX(0, CGRectGetMinX(aButton.frame)-aButton.frame.size.width/2.0);
            }
            else if (maxX>self.frame.size.width){
                x = MIN(CGRectGetMaxX(aButton.frame)+aButton.frame.size.width/2.0, mainScrollView.contentSize.width)-self.frame.size.width;
            }
            else{
                x = mainScrollView.contentOffset.x;
            }

            [mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
            
            selectedIndex = aButton.tag-9900;
            _sliderView.hidden = NO;
            KKWeakSelf(self)
            [UIView animateWithDuration:0.25 animations:^{
                weakself.sliderView.frame = CGRectMake((aButton.frame.origin.x+(aButton.frame.size.width-weakself.sliderView.frame.size.width)/2.0), weakself.mainScrollView.frame.size.height-2.0, weakself.sliderView.frame.size.width, 2.0);
            } completion:^(BOOL finished) {
                
            }];
            
            if (delegate && [delegate respondsToSelector:@selector(KKSegmentView:selectedNewIndex:)]) {
                [delegate KKSegmentView:self selectedNewIndex:selectedIndex];
            }
        }
    }
    else{
        [aButton setSelected:YES];
        
        CGRect windowFrame = [aButton convertRect:aButton.bounds toView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
        CGFloat maxX = windowFrame.origin.x+windowFrame.size.width;
        CGFloat x = 0;
        if (maxX<windowFrame.size.width) {
            x = MAX(0, CGRectGetMinX(aButton.frame)-aButton.frame.size.width/2.0);
        }
        else if (maxX>self.frame.size.width){
            x = MIN(CGRectGetMaxX(aButton.frame)+aButton.frame.size.width/2.0, mainScrollView.contentSize.width)-self.frame.size.width;
        }
        else{
            x = mainScrollView.contentOffset.x;
        }
        
        [mainScrollView setContentOffset:CGPointMake(x, 0) animated:YES];

        selectedIndex = aButton.tag-9900;
        _sliderView.hidden = NO;
        KKWeakSelf(self)
        [UIView animateWithDuration:0.25 animations:^{
            weakself.sliderView.frame = CGRectMake((aButton.frame.origin.x+(aButton.frame.size.width-weakself.sliderView.frame.size.width)/2.0), weakself.mainScrollView.frame.size.height-2.0, weakself.sliderView.frame.size.width, 2.0);
        } completion:^(BOOL finished) {
            
        }];
        
        if (delegate && [delegate respondsToSelector:@selector(KKSegmentView:selectedNewIndex:)]) {
            [delegate KKSegmentView:self selectedNewIndex:selectedIndex];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<=MaskViewWidth) {
        _leftMaskView.hidden = YES;
    }
    else if (MaskViewWidth<scrollView.contentOffset.x && scrollView.contentOffset.x<scrollView.contentSize.width-scrollView.frame.size.width-MaskViewWidth){
        _leftMaskView.hidden = NO;
        _rightMaskView.hidden = NO;
    }
    else{
        _rightMaskView.hidden = YES;
    }
}

- (void)deselect{
    KKButton *oldButton = (KKButton*)[mainScrollView viewWithTag:9900+selectedIndex];
    [oldButton setSelected:NO];
//    _sliderView.frame = CGRectZero;
    _sliderView.hidden = YES;
    selectedIndex = NSNotFound;
}


- (void)selectedIndex:(NSInteger)aIndex needRespondsDelegate:(BOOL)aNeedRespondsDelegate{
    KKButton *button = (KKButton*)[self buttonAtIndex:aIndex];
    if (aNeedRespondsDelegate) {
        [self buttonClicked:button];
    }
    else{
        [self deselect];
        [button setSelected:YES];
        _sliderView.hidden = NO;
        _sliderView.frame = CGRectMake((button.frame.origin.x+(button.frame.size.width-_sliderView.frame.size.width)/2.0), mainScrollView.frame.size.height-2.0, _sliderView.frame.size.width, 2.0);
        selectedIndex = aIndex;
    }
}

- (NSArray<KKButton*> *)allButtons{
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [mainScrollView subviews]) {
        if ([subView isKindOfClass:[KKButton class]] && subView.tag>=9900) {
            [array addObject:subView];
        }
    }
    return array;
}


- (KKButton*)buttonAtIndex:(NSInteger)aIndex{
    KKButton *oldButton = (KKButton*)[mainScrollView viewWithTag:9900+aIndex];
    return oldButton;
}


@end
