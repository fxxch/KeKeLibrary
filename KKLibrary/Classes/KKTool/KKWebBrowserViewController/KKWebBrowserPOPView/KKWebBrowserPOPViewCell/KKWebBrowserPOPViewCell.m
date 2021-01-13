//
//  KKWebBrowserPOPViewCell.m
//  YouJia
//
//  Created by liubo on 2018/6/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKWebBrowserPOPViewCell.h"

//cell的宽高设置
#define KKPopCollectionCell_Width  self.frame.size.width
#define KKPopCollectionCell_Height self.frame.size.height

#define KKPopCollectionCell_TitleFont [UIFont systemFontOfSize:12]
#define KKPopCollectionCell_TitleColor [UIColor colorWithRed:0.35 green:0.37 blue:0.41 alpha:1]

@implementation KKWebBrowserPOPViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIButton alloc]init];
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.layer.masksToBounds=YES;
        self.imageView.layer.cornerRadius = 15;
        [self.imageView addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imageView];
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = KKPopCollectionCell_TitleFont;
        self.titleLabel.textColor = KKPopCollectionCell_TitleColor;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews{
    self.imageView.frame = CGRectMake(0, 0, KKPopCollectionCell_Width, KKPopCollectionCell_Height-20);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, self.KKPopCollectionCell_Width, 20);
    [self.titleLabel sizeToFit];
    
    if (self.titleLabel.frame.size.width < KKPopCollectionCell_Width) {
        CGFloat titleX = (KKPopCollectionCell_Width - self.titleLabel.frame.size.width) * 0.5;
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = titleX;
        self.titleLabel.frame = frame;
    }
    
}

- (void)didClickButton:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWebBrowserPOPViewCell_DidClickedButton:)]) {
        [self.delegate KKWebBrowserPOPViewCell_DidClickedButton:self.index];
    }
}

@end
