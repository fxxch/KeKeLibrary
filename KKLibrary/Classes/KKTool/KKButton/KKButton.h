//
//  KKButton.h
//  GouUseCore
//
//  Created by liubo on 2017/6/14.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+KKWebCache.h"

/**
 *  KKButton类型
 */
typedef NS_ENUM(NSInteger, KKButtonType){
    
    /* 图片在上，文字在下，整体居左 */
    KKButtonType_ImgTopTitleBottom_Left = 11,
    
    /* 图片在上，文字在下，整体居中 */
    KKButtonType_ImgTopTitleBottom_Center = 12,

    /* 图片在上，文字在下，整体居右 */
    KKButtonType_ImgTopTitleBottom_Right = 13,

    
    /* 图片在下，文字在上，整体居左 */
    KKButtonType_ImgBottomTitleTop_Left = 21,

    /* 图片在下，文字在上，整体居中 */
    KKButtonType_ImgBottomTitleTop_Center = 22,

    /* 图片在下，文字在上，整体居右 */
    KKButtonType_ImgBottomTitleTop_Right = 23,
    
    
    /* 图片在左，文字在右，整体居左 */
    KKButtonType_ImgLeftTitleRight_Left = 31,

    /* 图片在左，文字在右，整体居中 */
    KKButtonType_ImgLeftTitleRight_Center = 32,
    
    /* 图片在左，文字在右，整体居右 */
    KKButtonType_ImgLeftTitleRight_Right = 33,
    
    
    /* 图片在右，文字在左，整体居左 */
    KKButtonType_ImgRightTitleLeft_Left = 41,

    /* 图片在右，文字在左，整体居中 */
    KKButtonType_ImgRightTitleLeft_Center = 42,

    /* 图片在右，文字在左，整体居右 */
    KKButtonType_ImgRightTitleLeft_Right = 43,


    /* 图片在左，文字在右，左右分散对齐 */
    KKButtonType_ImgLeftTitleRight_Edge = 51,

    /* 图片在右，文字在左，左右分散对齐 */
    KKButtonType_ImgRightTitleLeft_Edge = 52,

    
    /* 图片作为Button背景，文字在左上角 */
    KKButtonType_ImgFull_TitleLeftTop = 61,
    
    /* 图片作为Button背景，文字在左中 */
    KKButtonType_ImgFull_TitleLeftCenter = 62,

    /* 图片作为Button背景，文字在左下 */
    KKButtonType_ImgFull_TitleLeftBottom = 63,
    
    /* 图片作为Button背景，文字在中上 */
    KKButtonType_ImgFull_TitleCenterTop = 64,
    
    /* 图片作为Button背景，文字在中中 */
    KKButtonType_ImgFull_TitleCenterCenter = 65,
    
    /* 图片作为Button背景，文字在中下 */
    KKButtonType_ImgFull_TitleCenterBottom = 66,

    /* 图片作为Button背景，文字在右上 */
    KKButtonType_ImgFull_TitleRightTop = 67,
    
    /* 图片作为Button背景，文字在右中 */
    KKButtonType_ImgFull_TitleRightCenter = 68,
    
    /* 图片作为Button背景，文字在右下 */
    KKButtonType_ImgFull_TitleRightBottom = 69,

};

@interface KKButton : UIControl

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel     *textLabel;

@property (nonatomic,strong)UIImageView *topLineView;
@property (nonatomic,strong)UIImageView *leftLineView;
@property (nonatomic,strong)UIImageView *bottomLineView;
@property (nonatomic,strong)UIImageView *rightLineView;

@property (nonatomic,assign)KKButtonType buttonType;

//图片的大小（默认44x44）
@property (nonatomic,assign)CGSize     imageViewSize;
//上、左、下、右的边距（默认10）UIEdgeInsetsMake(10, 10, 10, 10) 当值为负数的时候就是0
@property (nonatomic,assign)UIEdgeInsets   edgeInsets;
//文字与图片之间的间距（默认10）
@property (nonatomic,assign)CGFloat   spaceBetweenImgTitle;
@property (nonatomic,assign)BOOL   drawnDarkerImageForHighlighted;//在Highlighted的时候是否让图片暗淡一点，默认为YES


- (instancetype)initWithFrame:(CGRect)frame type:(KKButtonType)aType;

#pragma mark -
#pragma mark ==================================================
#pragma mark == 样式
#pragma mark ==================================================
- (void)setImageWithURL:(NSURL *)aUrl
                  title:(NSString*)aTitle
             titleColor:(UIColor*)aTitleColor
        backgroundColor:(UIColor*)aBackgroundColor
               forState:(UIControlState)state;

- (void)setImage:(UIImage *)aImage
           title:(NSString*)aTitle
      titleColor:(UIColor*)aTitleColor
 backgroundColor:(UIColor*)aBackgroundColor
        forState:(UIControlState)state;

- (void)setTitle:(NSString *)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

- (void)setImage:(UIImage *)image forState:(UIControlState)state;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- (void)setImageWithURL:(NSURL *)url
               forState:(KKControlState)state
              completed:(KKImageLoadCompletedBlock)completedBlock;

- (UIImage*)imageForState:(UIControlState)state;

@end

@interface UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
@end

