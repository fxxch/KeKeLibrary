//
//  KKCameraToolBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/11.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageToolBar.h"
#import "KKAlbumManager.h"
#import "NSString+KKCategory.h"

@implementation KKCameraImageToolBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.25;
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];

    self.myImageButton = [[UIButton alloc] initWithFrame:CGRectMake(5, (self.frame.size.height-50)/2.0, 50, 50)];
    self.myImageButton.backgroundColor = [UIColor clearColor];
    [self.myImageButton addTarget:self action:@selector(imageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.myImageButton];
    
    /*拍照*/
    self.takePicButton = [[UIButton alloc] init];
    self.takePicButton.backgroundColor = [UIColor clearColor];
    self.takePicButton.frame = CGRectMake((self.frame.size.width-50)/2.0, (self.frame.size.height-50)/2.0, 50, 50);
    [self.takePicButton addTarget:self action:@selector(takePicButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image02 = [KKAlbumManager themeImageForName:@"TakePicN"];
    [self.takePicButton setImage:image02 forState:UIControlStateNormal];
    [self addSubview:self.takePicButton];
    
    
    self.infoBoxView = [[UIImageView alloc]initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoBoxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoBoxView];
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.infoLabel];
    
    [self setNumberOfPic:0 maxNumberOfPic:1];
}

/*图片*/
- (void)imageButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageToolBar_ImageButtonClicked:)]) {
        [self.delegate KKCameraImageToolBar_ImageButtonClicked:self];
    }
}

/*拍照*/
- (void)takePicButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageToolBar_TakePicButtonClicked:)]) {
        [self.delegate KKCameraImageToolBar_TakePicButtonClicked:self];
    }
}


- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{
    
    NSString *infoString = [NSString stringWithFormat:@"%ld/%ld ",(long)numberOfPic,(long)maxNumberOfPic];
    
    CGSize size = [infoString sizeWithFont:[UIFont systemFontOfSize:12] maxWidth:1000];
    
    self.infoBoxView.frame = CGRectMake(((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width-5-25-10-size.width, (self.frame.size.height-30)/2.0, size.width+35, 30);
    UIImage *image01 = [KKAlbumManager themeImageForName:@"RoundRectBox"];
    self.infoBoxView.image = [image01 stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.infoLabel.frame = CGRectMake(CGRectGetMinX(self.infoBoxView.frame)+25, (self.frame.size.height-30)/2.0, size.width, 30);
    self.infoLabel.text = infoString;
    
}

@end
