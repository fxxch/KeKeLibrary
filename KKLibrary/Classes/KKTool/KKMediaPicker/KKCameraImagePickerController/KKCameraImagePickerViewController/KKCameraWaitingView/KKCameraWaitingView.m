//
//  KKCameraWaitingView.m
//  BM
//
//  Created by 刘波 on 2020/2/24.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraWaitingView.h"

@implementation KKCameraWaitingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;

    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView startAnimating];
    activeView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    [self addSubview:activeView];
    self.hidden = YES;
}

@end
