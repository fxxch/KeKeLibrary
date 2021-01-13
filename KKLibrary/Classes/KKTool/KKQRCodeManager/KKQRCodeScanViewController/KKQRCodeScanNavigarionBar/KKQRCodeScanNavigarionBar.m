//
//  KKQRCodeScanNavigarionBar.m
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKQRCodeScanNavigarionBar.h"
#import "KKCategory.h"
#import "KKQRCodeManager.h"

@implementation KKQRCodeScanNavigarionBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
        
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.userInteractionEnabled = YES;
    [self addSubview:self.backgroundView];
    
    //标题
    UIFont *titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    CGSize size = [UIFont sizeOfFont:titleFont];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.height-44+(44-size.height)/2.0, self.width-140, size.height)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = titleFont;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];

    //左导航
    self.leftButton = [[KKButton alloc] initWithFrame:CGRectMake(0, self.height-44, 60, 44) type:KKButtonType_ImgLeftTitleRight_Left];
    self.leftButton.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.leftButton.spaceBetweenImgTitle = 0;
//    self.leftButton.imageViewSize = CGSizeMake(10.5, 19);
//    [self.leftButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavBack"] forState:UIControlStateNormal];
//    [self.leftButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavBack"] forState:UIControlStateHighlighted];
    self.leftButton.imageViewSize = CGSizeMake(25, 25);
    [self.leftButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavClose"] forState:UIControlStateNormal];
    [self.leftButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavClose"] forState:UIControlStateHighlighted];
    self.leftButton.exclusiveTouch = YES;//关闭多点
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.leftButton];

    //右导航
    self.rightButton = [[KKButton alloc] initWithFrame:CGRectMake(KKApplicationWidth-60, self.height-44, 60, 44) type:KKButtonType_ImgRightTitleLeft_Right];
    self.rightButton.imageViewSize = CGSizeMake(25, 25);
    self.rightButton.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    self.rightButton.spaceBetweenImgTitle = 0;
    [self.rightButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavAlbum"] forState:UIControlStateNormal];
    [self.rightButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavAlbum"] forState:UIControlStateHighlighted];
    self.rightButton.exclusiveTouch = YES;//关闭多点
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rightButton];
}

@end
