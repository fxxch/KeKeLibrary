//
//  KKView.m
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import "KKView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"

@interface KKView ()

@end

@implementation KKView

- (void)dealloc{
    [KKFileCacheManager deleteCacheDataInCacheDirectory:NSStringFromClass([self class])];
    [KKFileCacheManager deleteCacheDirectory:NSStringFromClass([self class])];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillHidden:(BOOL)hidden{
    [super viewWillHidden:hidden];
    if (hidden) {
        [self endEditing:YES];
    }
}

@end
