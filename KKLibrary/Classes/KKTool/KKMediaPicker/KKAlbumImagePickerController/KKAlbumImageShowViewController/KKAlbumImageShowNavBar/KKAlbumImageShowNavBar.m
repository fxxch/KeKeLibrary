//
//  KKAlbumImageShowNavBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowNavBar.h"
#import "KKAlbumManager.h"
#import "KKCategory.h"
#import "KKButton.h"
#import "KKAlbumImagePickerManager.h"

@interface KKAlbumImageShowNavBar ()

@property (nonatomic , assign) BOOL isSelectItem;

@end

@implementation KKAlbumImageShowNavBar

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
        
        
        UIImage *image02 = [KKAlbumManager themeImageForName:@"NavSelectedH"];
        self.rightButton = [[KKButton alloc] initWithFrame:CGRectMake(KKScreenWidth-45,self.height-44+(44-30)/2.0, 30, 30) type:KKButtonType_ImgLeftTitleRight_Center];
        self.rightButton.imageViewSize = CGSizeMake(30, 30);
        self.rightButton.spaceBetweenImgTitle = 0;
        self.rightButton.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.rightButton addTarget:self action:@selector(navRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
        
        self.rightButton.textLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton setCornerRadius:self.rightButton.width/2.0];
    }
    return self;
}

- (void)navBackButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowNavBar_LeftButtonClicked)]) {
        [self.delegate KKAlbumImageShowNavBar_LeftButtonClicked];
    }
}

- (void)navRightButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowNavBar_RightButtonClicked)]) {
        [self.delegate KKAlbumImageShowNavBar_RightButtonClicked];
    }
}

- (void)setSelect:(BOOL)select item:(KKAlbumAssetModal*)aModal{
    self.isSelectItem = select;
    
    if (select) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:aModal];
        NSString *title = [NSString stringWithInteger:index+1];
        self.rightButton.imageViewSize = CGSizeMake(0, 0);
        [self.rightButton setBackgroundColor:[UIColor colorWithHexString:@"#1E95FF"] forState:UIControlStateNormal];
        [self.rightButton setImage:nil
                          forState:UIControlStateNormal];
        [self.rightButton setTitle:title forState:UIControlStateNormal];
        [self.rightButton showZoomAnimation];
    }
    else{
        self.rightButton.imageViewSize = CGSizeMake(30, 30);
        UIImage *image02 = [KKAlbumManager themeImageForName:@"NavSelectedH"];
        [self.rightButton setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [self.rightButton setImage:image02
                          forState:UIControlStateNormal];
        [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    }

}

- (BOOL)isSelect{
    return self.isSelectItem;
}


@end
