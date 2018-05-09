//
//  KKDateSelectView.h
//  CEDongLi
//
//  Created by liubo on 16/6/14.
//  Copyright (c) 2016年 KeKeStudio. All rights reserved.
//

#import "KKView.h"

/**
 * 消息体类型枚举
 */
typedef NS_ENUM(NSInteger, KKDateSelectViewType) {
    
    /** 年 */
    KKDateSelectViewType_YYYY = 1,
    
    /** 年月 */
    KKDateSelectViewType_YYYYMM = 2,
    
    /** 年月日 */
    KKDateSelectViewType_YYYYMMDD = 3,
    
    /** 年月日时 */
    KKDateSelectViewType_YYYYMMDDHH = 4,
    
    /** 年月日时分 */
    KKDateSelectViewType_YYYYMMDDHHMM = 5,
    
    /** 年月日时分秒 */
    KKDateSelectViewType_YYYYMMDDHHMMSS = 6,
};


@protocol KKDateSelectViewDelegate;


@interface KKDateSelectView : KKView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView *dataPicker;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *dataSourceYear;
@property (nonatomic,strong) NSMutableArray *dataSourceMonth;
@property (nonatomic,strong) NSMutableArray *dataSourceDay;
@property (nonatomic,strong) NSMutableArray *dataSourceHour;
@property (nonatomic,strong) NSMutableArray *dataSourceMinute;
@property (nonatomic,strong) NSMutableArray *dataSourceSeconds;

@property (nonatomic,copy) NSString *identifierKey;//标识符（外面传进来，代理会返回改值，用以区分）
@property (nonatomic,copy) NSDate *inShowDate;
@property (nonatomic,copy) NSDate *inMinDate;
@property (nonatomic,copy) NSDate *inMaxDate;
@property (nonatomic,assign) KKDateSelectViewType showType;
@property (nonatomic,assign) id<KKDateSelectViewDelegate> delegate;

+ (void)showWithDelegate:(id<KKDateSelectViewDelegate>)aDelegate
                showDate:(NSDate*)aShowDate
                 minDate:(NSDate*)aMinDate
                 maxDate:(NSDate*)aMaxDate
                showType:(KKDateSelectViewType)aShowType
           identifierKey:(NSString*)aIdentifierKey;
@end


@protocol KKDateSelectViewDelegate <NSObject>
@optional

- (void)KKDateSelectView:(KKDateSelectView*)aDateSelectView willDismissWithIdentifierKey:(NSString*)aIdentifierKey;

- (void)KKDateSelectView:(KKDateSelectView*)aDateSelectView didFinishedWithDate:(NSDate *)aDate identifierKey:(NSString*)aIdentifierKey;

@end
