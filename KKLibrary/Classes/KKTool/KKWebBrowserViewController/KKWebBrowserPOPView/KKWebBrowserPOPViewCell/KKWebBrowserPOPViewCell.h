//
//  KKWebBrowserPOPViewCell.h
//  YouJia
//
//  Created by liubo on 2018/6/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKWebBrowserPOPViewCellDelegate;

@interface KKWebBrowserPOPViewCell : UICollectionViewCell

@property (nonatomic , strong) UIButton * imageView;
@property (nonatomic , strong) UILabel * titleLabel;
@property (nonatomic , assign) NSInteger index;

@property (nonatomic , weak) id<KKWebBrowserPOPViewCellDelegate> delegate;

@end


#pragma mark ==================================================
#pragma mark == KKWebBrowserPOPViewCellDelegate
#pragma mark ==================================================
@protocol KKWebBrowserPOPViewCellDelegate <NSObject>
@optional

- (void)KKWebBrowserPOPViewCell_DidClickedButton:(NSInteger)index;


@end

