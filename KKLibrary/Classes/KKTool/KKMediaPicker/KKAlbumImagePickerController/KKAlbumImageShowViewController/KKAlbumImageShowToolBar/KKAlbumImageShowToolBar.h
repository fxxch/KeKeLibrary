//
//  KKAlbumImageShowToolBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKAlbumImageShowToolBarDelegate;

@interface KKAlbumImageShowToolBar : UIView

@property(nonatomic,strong)UIImageView *infoBoxView;
@property(nonatomic,strong)UILabel *infoLabel;

@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)UIButton *originButton;

@property(nonatomic,strong)UIButton *okButton;

@property(nonatomic,weak)id<KKAlbumImageShowToolBarDelegate> delegate;

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic;


@end


@protocol KKAlbumImageShowToolBarDelegate <NSObject>

- (void)KKAlbumImageShowToolBar_EditButtonClicked:(KKAlbumImageShowToolBar*)toolView;

- (void)KKAlbumImageShowToolBar_OKButtonClicked:(KKAlbumImageShowToolBar*)toolView;

@end
