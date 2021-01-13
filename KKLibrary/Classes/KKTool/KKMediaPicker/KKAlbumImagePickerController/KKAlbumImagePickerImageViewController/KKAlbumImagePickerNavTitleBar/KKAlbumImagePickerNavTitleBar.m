//
//  KKAlbumImagePickerNavTitleBar.m
//  BM
//
//  Created by sjyt on 2020/3/23.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumImagePickerNavTitleBar.h"
#import "KKAlbumImagePickerManager.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"

@implementation KKAlbumImagePickerNavTitleBar

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self observeNotification:NotificationName_KKAlbumManagerLoadSourceFinished selector:@selector(Notification_KKAlbumManagerLoadSourceFinished:)];
    }
    return self;
}

- (void)initUI{
    NSString *title = KKLibLocalizable_Album_Photo;
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:1000];
    CGFloat width = 10 + size.width + 10 + 20 + 5;
    
    self.backgroundView = [[UIButton alloc] initWithFrame:CGRectMake((self.width-width)/2.0, (self.height-44)+(44-30)/2.0, width, 30)];
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#707070"];
    [self.backgroundView addTarget:self action:@selector(backgroundViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backgroundView];
    [self.backgroundView setCornerRadius:15];
    self.backgroundView.userInteractionEnabled = NO;

    self.titleLabel = [UILabel kk_initWithTextColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17] text:title];
    self.titleLabel.frame = CGRectMake(0, 0, 10 + size.width + 10, self.backgroundView.height);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.titleLabel];
    self.titleLabel.userInteractionEnabled = NO;

    self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(self.titleLabel.right, (self.backgroundView.height-20)/2.0, 20, 20)];
    [self.arrowButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    UIImage *image01 = [KKAlbumManager themeImageForName:@"NavArrowDown"];
    [self.arrowButton setImage:image01 forState:UIControlStateNormal];
    [self.arrowButton setCornerRadius:self.arrowButton.width/2.0];
    [self.backgroundView addSubview:self.arrowButton];
    self.arrowButton.userInteractionEnabled = NO;
    self.hidden = YES;
}

- (void)backgroundViewClicked{
    if (self.isOpen) {
        [self close];
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerNavTitleBar_Open:)]) {
            [self.delegate KKAlbumImagePickerNavTitleBar_Open:NO];
        }
    } else {
        [self open];
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerNavTitleBar_Open:)]) {
            [self.delegate KKAlbumImagePickerNavTitleBar_Open:YES];
        }
    }
}

- (void)close{
    if (self.isOpen==NO) return;
    self.isOpen = NO;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0*(M_PI/180.0f));
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.arrowButton.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)open{
    if (self.isOpen==YES) return;
    self.isOpen = YES;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(180*(M_PI/180.0f));
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.arrowButton.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)Notification_KKAlbumManagerLoadSourceFinished:(NSNotification*)notice{
    NSArray *aArray = notice.object;
    if ([NSArray isArrayEmpty:aArray]) {
        self.backgroundView.userInteractionEnabled = NO;
        self.hidden = YES;
    } else {
        self.backgroundView.userInteractionEnabled = YES;
        self.hidden = NO;
        NSArray *array = notice.object;
        for (NSInteger i=0; i<[array count]; i++) {
            KKAlbumDirectoryModal *data = (KKAlbumDirectoryModal*)[array objectAtIndex:i];
            if ([data.title isEqualToString:KKLibLocalizable_Album_UserLibrary]) {
                [self reloadWithDirectoryModal:data];
                break;
            }
        }
    }
}

- (void)reloadWithDirectoryModal:(KKAlbumDirectoryModal*)aModal{
    NSString *title = aModal.title;
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:1000];
    CGFloat width = 10 + size.width + 10 + 20 + 5;
    
    self.backgroundView.frame = CGRectMake((self.width-width)/2.0, (self.height-44)+(44-30)/2.0, width, 30);
    self.titleLabel.frame = CGRectMake(0, 0, 10 + size.width + 10, self.backgroundView.height);
    self.titleLabel.text = title;
    self.arrowButton.frame = CGRectMake(self.titleLabel.right, (self.backgroundView.height-20)/2.0, 20, 20);
}

@end
