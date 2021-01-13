//
//  KKDataPickerView.h
//  DayDayUp
//
//  Created by beartech on 15/7/6.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKDataPickerViewDelegate;

@interface KKDataPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,weak) id<KKDataPickerViewDelegate> delegate;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIPickerView *dataPicker;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *identifierKey;//标识符（外面传进来，代理会返回改值，用以区分）
@property (nonatomic,copy) NSString *textKey;//显示的文字的key,通过这个key从dataSource 里面的每个元素（字典）里面去取value

+ (KKDataPickerView*)showInView:(UIView*)view
                       delegate:(id<KKDataPickerViewDelegate>)delegate
                     dataSource:(NSArray*)aDataSource
                        textKey:(NSString*)aTextKey
                  identifierKey:(NSString*)aIdentifierKey;

+ (KKDataPickerView*)showWithDelegate:(id<KKDataPickerViewDelegate>)delegate
                           dataSource:(NSArray*)aDataSource
                              textKey:(NSString*)aTextKey
                        identifierKey:(NSString*)aIdentifierKey;

- (void)selectIndex:(NSInteger)aIndex animated:(BOOL)animated;

@end


@protocol KKDataPickerViewDelegate <NSObject>
@optional

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView cancelWithIdentifierKey:(NSString*)aIdentifierKey;

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView willDismissWithIdentifierKey:(NSString*)aIdentifierKey;

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView selectedInformation:(id)aInformation identifierKey:(NSString*)aIdentifierKey;

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView didSelectedInformation:(id)aInformation identifierKey:(NSString*)aIdentifierKey;


@end

NS_ASSUME_NONNULL_END
