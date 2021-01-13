//
//  KKCameraImageShowNavBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageShowNavBar.h"
#import "KKAlbumManager.h"
#import "KKButton.h"
#import "KKCategory.h"

@implementation KKCameraImageShowNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.75;
        backgroundView.userInteractionEnabled = YES;
        [self addSubview:backgroundView];

        self.titleLabel = [UILabel kk_initWithTextColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:17] text:@"9/9"];
        self.titleLabel.frame = CGRectMake(0, self.height-44+(44-self.titleLabel.height)/2.0, self.width, self.titleLabel.height);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        UIImage *image01 = [KKAlbumManager themeImageForName:@"NavBack"];
        self.backButton = [[KKButton alloc] initWithFrame:CGRectMake(0,self.height-44, 60, 44) type:KKButtonType_ImgLeftTitleRight_Center];
        self.backButton.imageViewSize = CGSizeMake(11, 18);
        self.backButton.spaceBetweenImgTitle = 0;
        self.backButton.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.backButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setImage:image01
                           forState:UIControlStateNormal];
        [self addSubview:self.backButton];

        UIImage *image02 = [KKAlbumManager themeImageForName:@"DeleteNav"];        
        self.rightButton = [[KKButton alloc] initWithFrame:CGRectMake(KKScreenWidth-60,self.height-44, 60, 44) type:KKButtonType_ImgLeftTitleRight_Center];
        self.rightButton.imageViewSize = CGSizeMake(20, 20);
        self.rightButton.spaceBetweenImgTitle = 0;
        self.rightButton.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [self.rightButton addTarget:self action:@selector(navRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)navBackButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowNavBar_LeftButtonClicked)]) {
        [self.delegate KKCameraImageShowNavBar_LeftButtonClicked];
    }
}

- (void)navRightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowNavBar_RightButtonClicked)]) {
        [self.delegate KKCameraImageShowNavBar_RightButtonClicked];
    }
}

@end
