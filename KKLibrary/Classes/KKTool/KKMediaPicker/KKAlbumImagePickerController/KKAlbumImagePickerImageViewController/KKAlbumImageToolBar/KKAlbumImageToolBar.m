//
//  KKAlbumImageToolBar.m
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageToolBar.h"
#import "KKAlbumImagePickerManager.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKSharedInstance.h"

#define KKAlbumImageToolBar_ButtonFont [UIFont boldSystemFontOfSize:14]
#define KKAlbumImageToolBar_InfoFont [UIFont systemFontOfSize:12]

@implementation KKAlbumImageToolBar

- (void)dealloc
{
    [self unobserveAllNotification];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self initUI];
        [self observeNotification:NotificationName_KKAlbumManagerIsSelectOriginChanged selector:@selector(Notification_KKAlbumManagerIsSelectOriginChanged:)];
    }
    return self;
}


- (void)initUI{
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];
    
    self.previewButton = [[UIButton alloc] initWithFrame:CGRectMake(KKApplicationWidth-15-60-15-60, 10, 60, 30)];
    [self.previewButton setBackgroundColor:[UIColor colorWithHexString:@"#1E95FF"] forState:UIControlStateNormal];
    self.previewButton.titleLabel.font = KKAlbumImageToolBar_ButtonFont;
    [self.previewButton setTitle:KKLibLocalizable_Album_Preview forState:UIControlStateNormal];
    self.previewButton.backgroundColor = [UIColor clearColor];
    [self.previewButton setCornerRadius:15.0];
    [self.previewButton addTarget:self action:@selector(previewButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previewButton];
    self.previewButton.hidden = YES;
    
    self.originButton = [[UIButton alloc] initWithFrame:CGRectMake((KKApplicationWidth-90)/2.0, 10, 90, 30)];
    [self.originButton setImage:KKThemeImage(@"icon_selectedN") forState:UIControlStateNormal];
    [self.originButton setImage:KKThemeImage(@"icon_selectedH") forState:UIControlStateSelected];
    self.originButton.titleLabel.font = KKAlbumImageToolBar_ButtonFont;
    [self.originButton setTitle:KKLibLocalizable_Album_Origin forState:UIControlStateNormal];
    self.originButton.backgroundColor = [UIColor clearColor];
    [self.originButton addTarget:self action:@selector(originButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.originButton];
    self.originButton.hidden = NO;
    [self.originButton setButtonContentAlignment:ButtonContentAlignmentCenter
                        ButtonContentLayoutModal:ButtonContentLayoutModalHorizontal
                      ButtonContentTitlePosition:ButtonContentTitlePositionAfter
                       SapceBetweenImageAndTitle:5.0
                                      EdgeInsets:UIEdgeInsetsZero];
    if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
        self.originButton.selected = YES;
    } else {
        self.originButton.selected = NO;
    }
    
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(KKApplicationWidth-15-60, 10, 60, 30)];
    [self.okButton setBackgroundColor:[UIColor colorWithHexString:@"#1E95FF"] forState:UIControlStateNormal];
    self.okButton.titleLabel.font = KKAlbumImageToolBar_ButtonFont;
    [self.okButton setTitle:KKLibLocalizable_Common_Done forState:UIControlStateNormal];
    self.okButton.backgroundColor = [UIColor clearColor];
    [self.okButton setCornerRadius:15.0];
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.okButton];
    
    self.infoBoxView = [[UIImageView alloc]initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoBoxView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoBoxView];
    self.infoBoxView.hidden = YES;
    
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(1 , 1, 1, 1)];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.font = KKAlbumImageToolBar_InfoFont;
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;

    [self setNumberOfPic:0 maxNumberOfPic:1];
    
    [self observeNotification:NotificationName_KKAlbumManagerDataSourceChanged selector:@selector(Notification_KKAlbumManagerDataSourceChanged:)];

    self.previewButton.frame = CGRectMake(15, 10, 60, 30);
}

/*预览*/
- (void)previewButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageToolBar_PreviewButtonClicked:)]) {
        [self.delegate KKAlbumImageToolBar_PreviewButtonClicked:self];
    }
}

/*原图*/
- (void)originButtonClicked{
    BOOL oldValue = KKAlbumImagePickerManager.defaultManager.isSelectOrigin;
    KKAlbumImagePickerManager.defaultManager.isSelectOrigin = !oldValue;
    [self postNotification:NotificationName_KKAlbumManagerIsSelectOriginChanged];
}

/*确定*/
- (void)okButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageToolBar_OKButtonClicked:)]) {
        [self.delegate KKAlbumImageToolBar_OKButtonClicked:self];
    }
}

- (void)setNumberOfPic:(NSInteger)numberOfPic maxNumberOfPic:(NSInteger)maxNumberOfPic{
    
    if (numberOfPic>0) {
        self.previewButton.hidden = NO;

        self.okButton.userInteractionEnabled = YES;
        self.okButton.alpha = 1.0;
        NSString *okTitle = [NSString stringWithFormat:@"%@(%ld)",KKLibLocalizable_Common_Done,(long)numberOfPic];
        CGSize size = [okTitle sizeWithFont:KKAlbumImageToolBar_ButtonFont maxWidth:1000];
        self.okButton.frame = CGRectMake(KKApplicationWidth-15-(size.width)-30, 10, size.width+30, 30);
        [self.okButton setTitle:okTitle forState:UIControlStateNormal];
    }
    else{
        self.previewButton.hidden = YES;

        self.okButton.userInteractionEnabled = NO;
        self.okButton.alpha = 0.3;
        [self.okButton setTitle:KKLibLocalizable_Common_Done forState:UIControlStateNormal];
        self.okButton.frame = CGRectMake(KKApplicationWidth-15-60, 10, 60, 30);
    }
    
    NSString *infoString = [NSString stringWithFormat:@"%ld/%ld ",(long)numberOfPic,(long)maxNumberOfPic];
    
    CGSize size = [infoString sizeWithFont:KKAlbumImageToolBar_InfoFont maxWidth:1000];
    
    self.infoBoxView.frame = CGRectMake(15, 10, size.width+35, 30);
    
    UIImage *image01 = [KKAlbumManager themeImageForName:@"RoundRectBox"];
    self.infoBoxView.image = [image01 stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
    self.infoLabel.frame = CGRectMake(CGRectGetMinX(self.infoBoxView.frame)+25, 10, size.width, 30);
    self.infoLabel.text = infoString;
    
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumManagerDataSourceChanged:(NSNotification*)notice{
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
    [self setNumberOfPic:selectNumber maxNumberOfPic:maxNumber];
}

- (void)Notification_KKAlbumManagerIsSelectOriginChanged:(NSNotification*)notice{
    if (KKAlbumImagePickerManager.defaultManager.isSelectOrigin) {
        self.originButton.selected = YES;
    } else {
        self.originButton.selected = NO;
    }
}



@end
