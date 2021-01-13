//
//  KKCameraImageShowToolBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKCameraImageShowToolBarDelegate;

@interface KKCameraImageShowToolBar : UIView

@property(nonatomic,strong)UIImageView *infoBoxView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIButton *okButton;

@property(nonatomic,weak)id<KKCameraImageShowToolBarDelegate> delegate;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;


@end


@protocol KKCameraImageShowToolBarDelegate <NSObject>

- (void)KKCameraImageShowToolBar_OKButtonClicked:(KKCameraImageShowToolBar*)toolView;

@end
