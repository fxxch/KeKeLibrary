//
//  KKDateSelectView.m
//  CEDongLi
//
//  Created by liubo on 16/6/14.
//  Copyright (c) 2016年 KeKeStudio. All rights reserved.
//

#import "KKDateSelectView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"

@implementation KKDateSelectView

//#define PickerHeight 216
#define PickerHeight 162

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ==================================================
#pragma mark == 接口
#pragma mark ==================================================
+ (void)showWithDelegate:(id<KKDateSelectViewDelegate>)aDelegate
                showDate:(NSDate*)aShowDate
                 minDate:(NSDate*)aMinDate
                 maxDate:(NSDate*)aMaxDate
                showType:(KKDateSelectViewType)aShowType
           identifierKey:(NSString*)aIdentifierKey{
    UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
    [KKDateSelectView showInView:window
                        delegate:aDelegate
                        showDate:aShowDate
                         minDate:aMinDate
                         maxDate:aMaxDate
                        showType:aShowType
                   identifierKey:aIdentifierKey];
}

+ (void)showInView:(UIView*)view
          delegate:(id<KKDateSelectViewDelegate>)aDelegate
          showDate:(NSDate*)aShowDate
           minDate:(NSDate*)aMinDate
           maxDate:(NSDate*)aMaxDate
          showType:(KKDateSelectViewType)aShowType
     identifierKey:(NSString*)aIdentifierKey{
    
    KKDateSelectView *picker_View = (KKDateSelectView*)[view viewWithTag:2016062801];
    if (picker_View) {
        return;
    }
    
    CGRect frame = CGRectMake(0,
                              view.frame.size.height,
                              ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width,
                              view.frame.size.height);
    
    KKDateSelectView *pickerView =
    [[KKDateSelectView alloc]initWithFrame:frame
                                  delegate:aDelegate
                                  showDate:aShowDate
                                   minDate:aMinDate
                                   maxDate:aMaxDate
                                  showType:aShowType
                             identifierKey:aIdentifierKey];
    pickerView.tag = 2016062801;
    [view addSubview:pickerView];
    [view bringSubviewToFront:pickerView];

    [UIView animateWithDuration:0.25 animations:^{
        pickerView.frame = CGRectOffset(pickerView.frame, 0, -view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (id)initWithFrame:(CGRect)frame
           delegate:(id<KKDateSelectViewDelegate>)aDelegate
           showDate:(NSDate*)aShowDate
            minDate:(NSDate*)aMinDate
            maxDate:(NSDate*)aMaxDate
           showType:(KKDateSelectViewType)aShowType
      identifierKey:(NSString*)aIdentifierKey
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = aDelegate;
        
        self.inMinDate = aMinDate;
        if (!self.inMinDate) {
            self.inMinDate = [NSDate getDateFromString:@"1971-01-01 00:00:00" dateFormatter:KKDateFormatter01];
        }
        self.inMaxDate = aMaxDate;
        if (!self.inMaxDate) {
            self.inMaxDate = [NSDate getDateFromString:@"2971-01-01 00:00:00" dateFormatter:KKDateFormatter01];
        }
        
        if ([NSDate isDate:aShowDate earlierThanDate:self.inMinDate] ||
            [NSDate isDate:self.inMaxDate earlierThanDate:self.inMaxDate] ||
            self.inShowDate==nil) {
            
            if (aShowDate && [aShowDate isKindOfClass:[NSDate class]]) {
                self.inShowDate = [aShowDate copy];
            }
            else{
                self.inShowDate = [[NSDate date] copy];
            }
        }
        
        self.showType = aShowType;
        self.identifierKey = [aIdentifierKey copy];
        
        int showY  = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"yyyy"] intValue];
        int showMM = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"MM"] intValue];
        int showD  = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"dd"] intValue];
        int showH  = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"HH"] intValue];
        int showM  = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"mm"] intValue];
        int showS  = [[NSDate getStringFromDate:self.inShowDate dateFormatter:@"ss"] intValue];
        
        //年
        NSInteger yearIndex = 0;
        self.dataSourceYear = [[NSMutableArray alloc] init];
        for (NSInteger year=1971; year<=2971; year++) {
            [self.dataSourceYear addObject:[NSString stringWithFormat:@"%04ld",(long)year]];
            if (year==showY) {
                yearIndex = year-1971;
            }
        }
        
        //月
        NSInteger monthIndex = 0;
        self.dataSourceMonth = [[NSMutableArray alloc] init];
        for (NSInteger month=1; month<=12; month++) {
            [self.dataSourceMonth addObject:[NSString stringWithFormat:@"%02ld",(long)month]];
            if (month==showMM) {
                monthIndex = month-1;
            }
        }
        
        //日
        NSInteger dayIndex = 0;
        self.dataSourceDay = [[NSMutableArray alloc] init];
        NSInteger maxDay = [self maxDayForYear:showY month:showMM];
        for (NSInteger day=1; day<=maxDay; day++) {
            [self.dataSourceDay addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
            if (day==showD) {
                dayIndex = day-1;
            }
        }
        
        //时
        NSInteger hourIndex = 0;
        self.dataSourceHour = [[NSMutableArray alloc] init];
        for (NSInteger hour=0; hour<=23; hour++) {
            [self.dataSourceHour addObject:[NSString stringWithFormat:@"%02ld",(long)hour]];
            if (hour==showH) {
                hourIndex = hour;
            }
        }
        
        //分
        NSInteger minuteIndex = 0;
        self.dataSourceMinute = [[NSMutableArray alloc] init];
        for (NSInteger minute=0; minute<=59; minute++) {
            [self.dataSourceMinute addObject:[NSString stringWithFormat:@"%02ld",(long)minute]];
            if (minute==showM) {
                minuteIndex = minute;
            }
        }
        
        //秒
        NSInteger secondsIndex = 0;
        self.dataSourceSeconds = [[NSMutableArray alloc] init];
        for (NSInteger seconds=0; seconds<=59; seconds++) {
            [self.dataSourceSeconds addObject:[NSString stringWithFormat:@"%02ld",(long)seconds]];
            if (seconds==showS) {
                secondsIndex = seconds;
            }
        }

        self.backgroundColor = [UIColor clearColor];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = self.bounds;
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        
        self.dataPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,frame.size.height-PickerHeight, frame.size.width, PickerHeight)];
        self.dataPicker.delegate = self;
        self.dataPicker.showsSelectionIndicator = YES;
        [self addSubview:self.dataPicker];
        
        [self setNavigationBarView];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            self.dataPicker.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = [UIColor blueColor];
        }
        else{
            self.dataPicker.backgroundColor = [UIColor blackColor];
            self.titleLabel.textColor = [UIColor whiteColor];
        }
        
        switch (self.showType) {
            case KKDateSelectViewType_YYYY:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                break;
            }
            case KKDateSelectViewType_YYYYMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:NO];
                break;
            }
            case KKDateSelectViewType_YYYYMMDD:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:NO];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:NO];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHH:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:NO];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:NO];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:NO];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:NO];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:NO];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:NO];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:NO];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMMSS:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:NO];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:NO];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:NO];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:NO];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:NO];
                [self.dataPicker selectRow:secondsIndex inComponent:5 animated:NO];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (int)maxDayForYear:(int)aYear month:(int)aMonth{
    
    int maxDay = 31;
    switch (aMonth) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            maxDay = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            maxDay = 30;
            break;
        }
        case 2:{
            if ((aYear%4==0 && aYear%100!=0) || aYear%400==0) {
                maxDay = 29;
            }
            else{
                maxDay = 28;
            }
            break;
        }
        default:
            break;
    }
    
    return maxDay;
}

- (void)singleTap{
    [self leftButtonClicked];
}

- (void)setNavigationBarView{
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.dataPicker.frame)-44, KKApplicationWidth, 44)];
    navigationBarView.backgroundColor = [UIColor colorWithHexString:@"#F2F5F9"];
    [self addSubview:navigationBarView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#E9EEF1"];
    [navigationBarView addSubview:line];
    
    NSString *leftTitle = KILocalization(@"取消");
    CGSize size = [leftTitle sizeWithFont:[UIFont systemFontOfSize:16.5] maxSize:CGSizeMake(1000, 1000)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width+30, navigationBarView.frame.size.height)];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithHexString:@"8899A9"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [navigationBarView addSubview:leftButton];
    
    //左空格
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width+30, 0, KKApplicationWidth-(size.width+30)*2.0, navigationBarView.frame.size.height)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [navigationBarView addSubview:self.titleLabel];
    
    
    NSString *rightTitle = KILocalization(@"确定");
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(KKApplicationWidth-(size.width+30), 0, size.width+30, navigationBarView.frame.size.height)];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [navigationBarView addSubview:rightButton];
}

- (void)leftButtonClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(KKDateSelectView:willDismissWithIdentifierKey:)]) {
        [_delegate KKDateSelectView:self willDismissWithIdentifierKey:self.identifierKey];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)rightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKDateSelectView:didFinishedWithDate:identifierKey:)]) {
        [self.delegate KKDateSelectView:self didFinishedWithDate:[self nowSelectedData] identifierKey:self.identifierKey];
    }
    
    [self leftButtonClicked];
}

- (void)reloadTitleLabel{
    switch (self.showType) {
        case KKDateSelectViewType_YYYY:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *dateString = [NSString stringWithFormat:@"%@",year];
            self.titleLabel.text = dateString;
            break;
        }
        case KKDateSelectViewType_YYYYMM:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@",year,month];
            self.titleLabel.text = dateString;
            break;
        }
        case KKDateSelectViewType_YYYYMMDD:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            self.titleLabel.text = dateString;
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHH:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,hour];
            self.titleLabel.text = dateString;
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMM:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *minute = [self.dataSourceMinute objectAtIndex:[self.dataPicker selectedRowInComponent:4]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
            self.titleLabel.text = dateString;
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMMSS:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *minute = [self.dataSourceMinute objectAtIndex:[self.dataPicker selectedRowInComponent:4]];
            NSString *seconds = [self.dataSourceSeconds objectAtIndex:[self.dataPicker selectedRowInComponent:5]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,minute,seconds];
            self.titleLabel.text = dateString;
            break;
        }
        default:
            break;
    }
}

#pragma mark ==================================================
#pragma mark == PickerViewDelegate
#pragma mark ==================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.showType;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return [self.dataSourceYear count];
    }
    else if (component==1){
        return [self.dataSourceMonth count];
    }
    else if (component==2){
        return [self.dataSourceDay count];
    }
    else if (component==3){
        return [self.dataSourceHour count];
    }
    else if (component==4){
        return [self.dataSourceMinute count];
    }
    else{
        return [self.dataSourceSeconds count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    CGFloat returnWidth = 0;
    
    switch (self.showType) {
        case KKDateSelectViewType_YYYY:{
            returnWidth = (self.frame.size.width-20);
            break;
        }
        case KKDateSelectViewType_YYYYMM:{
            if (component==0) {
                returnWidth = (self.frame.size.width-20)*6/10;
            }
            else{
                returnWidth = (self.frame.size.width-20)*4/10;
            }
            
            break;
        }
        case KKDateSelectViewType_YYYYMMDD:{
            if (component==0) {
                returnWidth = (self.frame.size.width-20)*6/14;
            }
            else{
                returnWidth = (self.frame.size.width-20)*4/14;
            }
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHH:{
            if (component==0) {
                returnWidth = (self.frame.size.width-20)*6/18;
            }
            else{
                returnWidth = (self.frame.size.width-20)*4/18;
            }
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMM:{
            if (component==0) {
                returnWidth = (self.frame.size.width-20)*6/22;
            }
            else{
                returnWidth = (self.frame.size.width-20)*4/22;
            }
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMMSS:{
            if (component==0) {
                returnWidth = (self.frame.size.width-20)*6/26;
            }
            else{
                returnWidth = (self.frame.size.width-20)*4/26;
            }
            break;
        }
        default:
            break;
    }
    
    return returnWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSString *text = nil;
    if (component==0) {
        text = [NSString stringWithFormat:@"%@年",[self.dataSourceYear objectAtIndex:row]];
    }
    else if (component==1){
        text = [NSString stringWithFormat:@"%@月",[self.dataSourceMonth objectAtIndex:row]];
    }
    else if (component==2){
        text = [NSString stringWithFormat:@"%@日",[self.dataSourceDay objectAtIndex:row]];
    }
    else if (component==3){
        text = [NSString stringWithFormat:@"%@时",[self.dataSourceHour objectAtIndex:row]];
    }
    else if (component==4){
        text = [NSString stringWithFormat:@"%@分",[self.dataSourceMinute objectAtIndex:row]];
    }
    else{
        text = [NSString stringWithFormat:@"%@秒",[self.dataSourceSeconds objectAtIndex:row]];
    }

    if (view && [view isKindOfClass:[UILabel class]]) {
        UILabel *textLable = (UILabel*)view;
        textLable.font = [UIFont boldSystemFontOfSize:17];
        textLable.textAlignment = NSTextAlignmentCenter;
        [textLable setBorderColor:[UIColor redColor] width:1.0];
        textLable.text = text;
        [textLable clearBackgroundColor];
        return textLable;
    }
    else{
        CGFloat perWidth = self.dataPicker.frame.size.width/(self.showType+1);
        CGFloat width = 0;
        if (component==0) {
            width = perWidth*2;
        }
        else{
            width = perWidth;
        }

        UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        textLable.font = [UIFont boldSystemFontOfSize:17];
        textLable.textAlignment = NSTextAlignmentCenter;
//        [textLable setBorderColor:[UIColor redColor] width:1.0];
        textLable.text = text;
        [textLable clearBackgroundColor];
        return textLable;
    }
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0){
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        if (self.showType>KKDateSelectViewType_YYYYMM) {
            int year = [[self.dataSourceYear objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
            int month = [[self.dataSourceMonth objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
            int maxDay = [self maxDayForYear:year month:month];
            int maxDayOld = [[self.dataSourceDay lastObject] intValue];
            if (maxDay!=maxDayOld) {
                NSInteger dayIndex_Old = [pickerView selectedRowInComponent:2];
                [self.dataSourceDay removeAllObjects];
                for (NSInteger day=1; day<=maxDay; day++) {
                    [self.dataSourceDay addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
                }
                
                [pickerView reloadComponent:2];
                
                if (dayIndex_Old<[self.dataSourceDay count]) {
                    [pickerView selectRow:dayIndex_Old inComponent:2 animated:NO];
                }
                else{
                    [pickerView selectRow:[self.dataSourceDay count]-1 inComponent:2 animated:YES];
                }
            }
        }
    }
    else if (component==1){
        if (self.showType>KKDateSelectViewType_YYYYMM) {
            int year = [[self.dataSourceYear objectAtIndex:[pickerView selectedRowInComponent:0]] intValue];
            int month = [[self.dataSourceMonth objectAtIndex:[pickerView selectedRowInComponent:1]] intValue];
            int maxDay = [self maxDayForYear:year month:month];
            int maxDayOld = [[self.dataSourceDay lastObject] intValue];
            if (maxDay!=maxDayOld) {
                NSInteger dayIndex_Old = [pickerView selectedRowInComponent:2];
                [self.dataSourceDay removeAllObjects];
                for (NSInteger day=1; day<=maxDay; day++) {
                    [self.dataSourceDay addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
                }
                
                [pickerView reloadComponent:2];
                
                if (dayIndex_Old<[self.dataSourceDay count]) {
                    [pickerView selectRow:dayIndex_Old inComponent:2 animated:NO];
                }
                else{
                    [pickerView selectRow:[self.dataSourceDay count]-1 inComponent:2 animated:YES];
                }
            }
        }
    }
    else if (component==2){

    }
    else if (component==3){

    }
    else if (component==4){

    }
    else{

    }
    
    NSDate *nowDate = [self nowSelectedData];
    NSLog(@"%@",[NSDate getStringFromDate:nowDate dateFormatter:KKDateFormatter01]);
    
    [self reloadTitleLabel];
}

- (NSDate*)nowSelectedData{

    NSDate *date = nil;
    
    switch (self.showType) {
        case KKDateSelectViewType_YYYY:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *dateString = [NSString stringWithFormat:@"%@-01-01 12:00:00",year];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        case KKDateSelectViewType_YYYYMM:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-01 12:00:00",year,month];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        case KKDateSelectViewType_YYYYMMDD:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ 12:00:00",year,month,day];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHH:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:00:00",year,month,day,hour];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMM:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *minute = [self.dataSourceMinute objectAtIndex:[self.dataPicker selectedRowInComponent:4]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        case KKDateSelectViewType_YYYYMMDDHHMMSS:{
            NSString *year = [self.dataSourceYear objectAtIndex:[self.dataPicker selectedRowInComponent:0]];
            NSString *month = [self.dataSourceMonth objectAtIndex:[self.dataPicker selectedRowInComponent:1]];
            NSString *day = [self.dataSourceDay objectAtIndex:[self.dataPicker selectedRowInComponent:2]];
            NSString *hour = [self.dataSourceHour objectAtIndex:[self.dataPicker selectedRowInComponent:3]];
            NSString *minute = [self.dataSourceMinute objectAtIndex:[self.dataPicker selectedRowInComponent:4]];
            NSString *seconds = [self.dataSourceSeconds objectAtIndex:[self.dataPicker selectedRowInComponent:5]];
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,minute,seconds];
            date = [NSDate getDateFromString:dateString dateFormatter:KKDateFormatter01];
            break;
        }
        default:
            break;
    }
    
    if ([NSDate isDate:date earlierThanDate:self.inMinDate]) {
        
        int showY  = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"yyyy"] intValue];
        int showMM = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"MM"] intValue];
        int showD  = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"dd"] intValue];
        int showH  = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"HH"] intValue];
        int showM  = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"mm"] intValue];
        int showS  = [[NSDate getStringFromDate:self.inMinDate dateFormatter:@"ss"] intValue];

        //年
        NSInteger yearIndex = showY-1971;
        
        //月
        NSInteger monthIndex = showMM-1;
        
        //日
        [self.dataSourceDay removeAllObjects];
        NSInteger dayIndex = 0;
        NSInteger maxDay = [self maxDayForYear:showY month:showMM];
        for (NSInteger day=1; day<=maxDay; day++) {
            [self.dataSourceDay addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
            if (day==showD) {
                dayIndex = day-1;
            }
        }
        if (self.showType>KKDateSelectViewType_YYYYMM) {
            [self.dataPicker reloadComponent:2];
            [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
        }
        
        //时
        NSInteger hourIndex = showH;
        
        //分
        NSInteger minuteIndex = showM;
        
        //秒
        NSInteger secondsIndex = showS;

        switch (self.showType) {
            case KKDateSelectViewType_YYYY:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDD:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHH:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMMSS:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:YES];
                [self.dataPicker selectRow:secondsIndex inComponent:5 animated:YES];
                break;
            }
            default:
                break;
        }

        return [NSDate dateWithTimeIntervalSince1970:[self.inMinDate timeIntervalSince1970]];
    }
    else if ([NSDate isDate:self.inMaxDate earlierThanDate:date]){
        int showY  = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"yyyy"] intValue];
        int showMM = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"MM"] intValue];
        int showD  = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"dd"] intValue];
        int showH  = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"HH"] intValue];
        int showM  = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"mm"] intValue];
        int showS  = [[NSDate getStringFromDate:self.inMaxDate dateFormatter:@"ss"] intValue];
        
        //年
        NSInteger yearIndex = showY-1971;
        
        //月
        NSInteger monthIndex = showMM-1;
        
        //日
        [self.dataSourceDay removeAllObjects];
        NSInteger dayIndex = 0;
        NSInteger maxDay = [self maxDayForYear:showY month:showMM];
        for (NSInteger day=1; day<=maxDay; day++) {
            [self.dataSourceDay addObject:[NSString stringWithFormat:@"%02ld",(long)day]];
            if (day==showD) {
                dayIndex = day-1;
            }
        }
        if (self.showType>KKDateSelectViewType_YYYYMM) {
            [self.dataPicker reloadComponent:2];
            [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
        }
        
        //时
        NSInteger hourIndex = showH;
        
        //分
        NSInteger minuteIndex = showM;
        
        //秒
        NSInteger secondsIndex = showS;
        
        switch (self.showType) {
            case KKDateSelectViewType_YYYY:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDD:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHH:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMM:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:YES];
                break;
            }
            case KKDateSelectViewType_YYYYMMDDHHMMSS:{
                [self.dataPicker selectRow:yearIndex inComponent:0 animated:YES];
                [self.dataPicker selectRow:monthIndex inComponent:1 animated:YES];
                [self.dataPicker selectRow:dayIndex inComponent:2 animated:YES];
                [self.dataPicker selectRow:hourIndex inComponent:3 animated:YES];
                [self.dataPicker selectRow:minuteIndex inComponent:4 animated:YES];
                [self.dataPicker selectRow:secondsIndex inComponent:5 animated:YES];
                break;
            }
            default:
                break;
        }
        
        return [NSDate dateWithTimeIntervalSince1970:[self.inMaxDate timeIntervalSince1970]];
    }
    else{
        return date;
    }
}

@end

