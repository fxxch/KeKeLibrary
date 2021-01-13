//
//  KKDataPickerView.m
//  DayDayUp
//
//  Created by beartech on 15/7/6.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKDataPickerView.h"
#import "KKLibraryDefine.h"
#import "KKCategory.h"
#import "KKLocalizationManager.h"

@implementation KKDataPickerView

#define KKDP_PickerHeight 216
//#define PickerHeight 162

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (id)initWithFrame:(CGRect)frame
           delegate:(id<KKDataPickerViewDelegate>)aDelegate
         dataSource:(NSArray*)aDataSource
            textKey:(NSString*)aTextKey
      identifierKey:(NSString*)aIdentifierKey{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = aDelegate;
        self.dataSource = [[NSMutableArray alloc] init];
        [self.dataSource addObjectsFromArray:aDataSource];
        
        self.textKey = aTextKey;
        self.identifierKey = aIdentifierKey;

        self.backgroundColor = [UIColor clearColor];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = self.bounds;
        self.backButton.backgroundColor = [UIColor blackColor];
        [self.backButton addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.backButton];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, KKScreenHeight, KKApplicationWidth, KKDP_PickerHeight+44+KKSafeAreaBottomHeight)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        [self setNavigationBarView];

        self.dataPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,44, KKApplicationWidth, KKDP_PickerHeight)];
        self.dataPicker.delegate = self;
        self.dataPicker.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.dataPicker];
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)singleTap{
    [self leftButtonClicked];
}

- (void)setNavigationBarView{
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 44)];
    [self.contentView addSubview:barView];
    
    CGSize size = [KKLibLocalizable_Common_OK sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:1000];
    
    //左按钮
    UIButton *leftButton = [UIButton kk_initWithFrame:CGRectMake(0, 0, size.width+30, barView.height) title:KKLibLocalizable_Common_Cancel titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor colorWithHexString:@"#1296DB"] backgroundColor:nil];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:leftButton];

    //标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftButton.right+10, 0, KKApplicationWidth-(leftButton.right+10)*2.0, barView.height)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [barView addSubview:self.titleLabel];
    
    UIButton *rightButton = [UIButton kk_initWithFrame:CGRectMake(KKApplicationWidth-(size.width+30), 0, size.width+30, barView.height) title:KKLibLocalizable_Common_OK titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor colorWithHexString:@"#1296DB"] backgroundColor:nil];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:rightButton];
    
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 1.0)];
    lineTop.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    [barView addSubview:lineTop];
}

- (void)selectIndex:(NSInteger)aIndex animated:(BOOL)animated{
    if (aIndex<self.dataSource.count) {
        [self.dataPicker selectRow:aIndex inComponent:0 animated:animated];
    }
}

#pragma mark ==================================================
#pragma mark == 接口
#pragma mark ==================================================
+ (KKDataPickerView*)showInView:(UIView*)view
                       delegate:(id<KKDataPickerViewDelegate>)delegate
                     dataSource:(NSArray*)aDataSource
                        textKey:(NSString*)aTextKey
                  identifierKey:(NSString*)aIdentifierKey{

    CGRect frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    KKDataPickerView *pickerView = [[KKDataPickerView alloc]initWithFrame:frame
                                                                 delegate:delegate
                                                               dataSource:aDataSource
                                                                  textKey:aTextKey
                                                            identifierKey:aIdentifierKey];
    pickerView.tag = 2015070601;
    [view addSubview:pickerView];
    [view bringSubviewToFront:pickerView];

    [pickerView show];
    return pickerView;
}

+ (KKDataPickerView*)showWithDelegate:(id<KKDataPickerViewDelegate>)delegate
                           dataSource:(NSArray*)aDataSource
                              textKey:(NSString*)aTextKey
                        identifierKey:(NSString*)aIdentifierKey{
    return [KKDataPickerView showInView:[UIWindow currentKeyWindow]
                               delegate:delegate
                             dataSource:aDataSource
                                textKey:aTextKey
                          identifierKey:aIdentifierKey];
}


#pragma mark ==================================================
#pragma mark == PickerViewDelegate
#pragma mark ==================================================
- (void)leftButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKDataPickerView:cancelWithIdentifierKey:)]) {
        [self.delegate KKDataPickerView:self cancelWithIdentifierKey:self.identifierKey];
    }
    [self hide];
}

- (void)rightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKDataPickerView:didSelectedInformation:identifierKey:)]) {
        [self.delegate KKDataPickerView:self didSelectedInformation:[self.dataSource objectAtIndex:[self.dataPicker selectedRowInComponent:0]] identifierKey:self.identifierKey];
    }
    [self hide];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataSource count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.dataPicker.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSObject *obj = [self.dataSource objectAtIndex:row];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if (obj && [obj isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary*)obj stringValueForKey:self.textKey];
    }
    else{
        return @"";
    }
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0){
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKDataPickerView:selectedInformation:identifierKey:)]) {
        [self.delegate KKDataPickerView:self selectedInformation:[self.dataSource objectAtIndex:row] identifierKey:self.identifierKey];
    }
}

- (void)show{
    
    self.backButton.alpha = 0;
    self.contentView.frame = CGRectMake(0, KKScreenHeight, KKApplicationWidth, KKDP_PickerHeight+44+KKSafeAreaBottomHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, KKScreenHeight-(KKDP_PickerHeight+44+KKSafeAreaBottomHeight), KKApplicationWidth, KKDP_PickerHeight+44+KKSafeAreaBottomHeight);
        self.backButton.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.frame = CGRectMake(0, KKScreenHeight, KKApplicationWidth, KKDP_PickerHeight+44+KKSafeAreaBottomHeight);
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKDataPickerView:willDismissWithIdentifierKey:)]) {
            [self.delegate KKDataPickerView:self willDismissWithIdentifierKey:self.identifierKey];
        }
        [self removeFromSuperview];
    }];
}


@end
