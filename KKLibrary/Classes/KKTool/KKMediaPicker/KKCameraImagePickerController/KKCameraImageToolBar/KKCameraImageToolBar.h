//
//  KKCameraImageToolBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/11.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KKCameraImageToolBarDelegate;

@interface KKCameraImageToolBar : UIImageView


@property(nonatomic,strong)UIImageView *infoBoxView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIButton *takePicButton;

@property(nonatomic,strong)UIButton *myImageButton;

@property(nonatomic,weak)id<KKCameraImageToolBarDelegate> delegate;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;


@end


@protocol KKCameraImageToolBarDelegate <NSObject>

/*图片*/
- (void)KKCameraImageToolBar_ImageButtonClicked:(KKCameraImageToolBar*)toolView;

/*照相*/
- (void)KKCameraImageToolBar_TakePicButtonClicked:(KKCameraImageToolBar*)toolView;

@end
