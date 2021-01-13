//
//  KKAlbumImageToolBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"

@protocol KKAlbumImageToolBarDelegate;

@interface KKAlbumImageToolBar : UIImageView

@property(nonatomic,strong)UIImageView *infoBoxView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIButton *previewButton;
@property(nonatomic,strong)UIButton *originButton;

@property(nonatomic,strong)UIButton *okButton;

@property(nonatomic,weak)id<KKAlbumImageToolBarDelegate> delegate;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;


@end


@protocol KKAlbumImageToolBarDelegate <NSObject>

- (void)KKAlbumImageToolBar_PreviewButtonClicked:(KKAlbumImageToolBar*)toolView;

- (void)KKAlbumImageToolBar_OKButtonClicked:(KKAlbumImageToolBar*)toolView;

@end
