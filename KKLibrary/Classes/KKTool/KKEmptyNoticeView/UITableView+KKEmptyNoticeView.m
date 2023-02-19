//
//  UITableView+KKEmptyNoticeView.m
//  YouJia
//
//  Created by liubo on 2018/6/30.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "UITableView+KKEmptyNoticeView.h"
#import "KKCategory.h"

@implementation UITableView (KKEmptyNoticeView)
@dynamic emptyDataIconImage;
@dynamic emptyDataButton;
@dynamic emptyDataText;
@dynamic emptyDataTextAlignment;
@dynamic emptyDataOffsetY;
@dynamic emptyDataViewDelegate;


#pragma mark ==================================================
#pragma mark == 数据为空的时候的提示界面
#pragma mark ==================================================
- (void)setEmptyDataIconImage:(UIImage *)emptyDataIconImage{
    objc_setAssociatedObject(self, @"EmptyDataIconImage", emptyDataIconImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)emptyDataIconImage{
    UIImage *image = objc_getAssociatedObject(self, @"EmptyDataIconImage");
    return image;
}

- (void)setEmptyDataButton:(KKButton *)emptyDataButton{
    objc_setAssociatedObject(self, @"EmptyDataButton", emptyDataButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KKButton *)emptyDataButton{
    KKButton *button = objc_getAssociatedObject(self, @"EmptyDataButton");
    return button;
}

- (void)setEmptyDataText:(NSString *)emptyDataText{
    objc_setAssociatedObject(self, @"EmptyDataText", emptyDataText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyDataText{
    NSString *text = objc_getAssociatedObject(self, @"EmptyDataText");
    return text;
}

- (void)setEmptyDataTextAlignment:(KKEmptyNoticeViewAlignment)emptyDataTextAlignment{
    objc_setAssociatedObject(self, @"EmptyDataTextAlignment",[NSNumber numberWithInteger:emptyDataTextAlignment], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KKEmptyNoticeViewAlignment)emptyDataTextAlignment{
    NSNumber *number = objc_getAssociatedObject(self, @"EmptyDataTextAlignment");
    return [number intValue];
}

- (void)setEmptyDataOffsetY:(CGFloat)emptyDataOffsetY{
    objc_setAssociatedObject(self, @"EmptyDataOffsetY",[NSNumber numberWithFloat:emptyDataOffsetY], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)emptyDataOffsetY{
    NSNumber *number = objc_getAssociatedObject(self, @"EmptyDataOffsetY");
    return [number floatValue];
}

- (void)setEmptyDataViewDelegate:(id<UITableViewEmptyNoticeViewDelegate>)emptyDataViewDelegate{
    objc_setAssociatedObject(self, @"EmptyNoticeViewDelegate",emptyDataViewDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UITableViewEmptyNoticeViewDelegate>)emptyDataViewDelegate{
    id<UITableViewEmptyNoticeViewDelegate> delegate = objc_getAssociatedObject(self, @"EmptyNoticeViewDelegate");
    return delegate;
}

- (void)kk_ShowEmptyNoticeView{
    
    [self kk_HideEmptyNoticeView];
    
    UIView *fullView = [[UIView alloc] initWithFrame:self.bounds];
    [fullView kk_clearBackgroundColor];
    fullView.tag = 2018063002;
    
    if (self.backgroundView) {
        fullView.frame = self.backgroundView.bounds;
        [self.backgroundView addSubview:fullView];
    }
    else{
        self.backgroundView = fullView;
    }
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.emptyDataOffsetY, fullView.frame.size.width, fullView.frame.size.height-self.emptyDataOffsetY)];
    emptyView.backgroundColor = [UIColor clearColor];
    [fullView addSubview:emptyView];


    //布局
    CGSize imageSize = self.emptyDataIconImage.size;
    if (self.emptyDataIconImage.size.width>emptyView.frame.size.width) {
        CGFloat width = emptyView.frame.size.width;
        CGFloat height = (width * self.emptyDataIconImage.size.height)/(self.emptyDataIconImage.size.width);
        imageSize = CGSizeMake(width, height);
    }
    
    UIFont *textFont = [UIFont systemFontOfSize:13];
    UIColor *textColor = [UIColor lightGrayColor];
    CGFloat spaceBetween_imagetext = 24;
    CGFloat spaceBetween_textbutton = 8;
    CGFloat button_height = self.emptyDataButton.frame.size.height;
    CGSize textSize = [self.emptyDataText kk_sizeWithFont:textFont
                                                  maxSize:CGSizeMake(emptyView.bounds.size.width-30, 10000)];
    CGFloat Y = 0;
    if (self.emptyDataTextAlignment==KKEmptyNoticeViewAlignment_Top) {
        Y = 40;
    }
    else if (self.emptyDataTextAlignment==KKEmptyNoticeViewAlignment_Center) {
        if (self.emptyDataButton==nil) {
            spaceBetween_textbutton = 0;
            Y = (emptyView.bounds.size.height-imageSize.height-spaceBetween_imagetext-textSize.height)/2.0;
        }
        else{
            Y = (emptyView.bounds.size.height-imageSize.height-spaceBetween_imagetext-textSize.height-spaceBetween_textbutton-button_height)/2.0;
        }
    }
    else{

    }
    
    if (self.emptyDataIconImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((fullView.bounds.size.width-imageSize.width)/2.0, Y, imageSize.width, imageSize.height)];
        imageView.image = self.emptyDataIconImage;
        [emptyView addSubview:imageView];
        Y = Y + imageSize.height;
        
        Y = Y + spaceBetween_imagetext;
        
        UIButton *buton = [[UIButton alloc] initWithFrame:imageView.frame];
        buton.backgroundColor = [UIColor clearColor];
        [buton addTarget:self action:@selector(emptyDataIconImageClicked) forControlEvents:UIControlEventTouchUpInside];
        [emptyView addSubview:buton];
    }
    
    if ([NSString kk_isStringNotEmpty:self.emptyDataText]) {
        UILabel *vTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, Y, fullView.bounds.size.width-30, textSize.height)];
        vTitleLabel.text = self.emptyDataText;
        vTitleLabel.textAlignment = NSTextAlignmentCenter;
        vTitleLabel.numberOfLines = 0;
        vTitleLabel.textColor = textColor;
        vTitleLabel.font = textFont;
        [emptyView addSubview:vTitleLabel];
        Y = Y + textSize.height;
        
        UIButton *buton = [[UIButton alloc] initWithFrame:vTitleLabel.frame];
        buton.backgroundColor = [UIColor clearColor];
        [buton addTarget:self action:@selector(emptyDataTextClicked) forControlEvents:UIControlEventTouchUpInside];
        [emptyView addSubview:buton];
    }
    
    Y = Y + spaceBetween_textbutton;
    if (self.emptyDataButton) {
        self.emptyDataButton.frame = CGRectMake((emptyView.bounds.size.width-self.emptyDataButton.frame.size.width)/2.0, Y, self.emptyDataButton.frame.size.width, button_height);
        [self.emptyDataButton addTarget:self action:@selector(emptyDataButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [emptyView addSubview:self.emptyDataButton];
    }
}

- (void)kk_HideEmptyNoticeView{
    if (self.backgroundView.tag==2018063002) {
        self.backgroundView = nil;
    }
    else{
        UIView *fullView = [self.backgroundView viewWithTag:2018063002];
        [fullView removeFromSuperview];
    }
}

- (void)emptyDataIconImageClicked{
    if (self.emptyDataViewDelegate && [self.emptyDataViewDelegate respondsToSelector:@selector(tableViewEmptyNoticeView_emptyDataIconImageClicked)]) {
        [self.emptyDataViewDelegate tableViewEmptyNoticeView_emptyDataIconImageClicked];
    }
}

- (void)emptyDataTextClicked{
    if (self.emptyDataViewDelegate && [self.emptyDataViewDelegate respondsToSelector:@selector(tableViewEmptyNoticeView_emptyDataTextClicked)]) {
        [self.emptyDataViewDelegate tableViewEmptyNoticeView_emptyDataTextClicked];
    }
}

- (void)emptyDataButtonClicked:(KKButton*)aButton{
    if (self.emptyDataViewDelegate && [self.emptyDataViewDelegate respondsToSelector:@selector(tableViewEmptyNoticeView_emptyDataButtonClicked:)]) {
        [self.emptyDataViewDelegate tableViewEmptyNoticeView_emptyDataButtonClicked:self.emptyDataButton];
    }
}

#pragma mark ==================================================
#pragma mark == viewWillAppear、viewWillHidden
#pragma mark ==================================================
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sys_SEL = @selector(reloadData);
        SEL my_SEL = @selector(kk_reloadData);
        
        Method sys_Method   = class_getInstanceMethod(self, sys_SEL);
        Method my_Method    = class_getInstanceMethod(self, my_SEL);
        
        BOOL didAddMethod = class_addMethod([self class],
                                            sys_SEL,
                                            method_getImplementation(my_Method),
                                            method_getTypeEncoding(my_Method));
        
        if (didAddMethod) {
            class_replaceMethod([self class],
                                my_SEL,
                                method_getImplementation(sys_Method),
                                method_getTypeEncoding(sys_Method));
        }
        method_exchangeImplementations(sys_Method, my_Method);
        
    });
    
}

- (void)kk_reloadData{
    
    [self kk_reloadData];
    
    NSInteger rowsCount = [[self visibleCells] count];
    if (rowsCount==0) {
        [self kk_ShowEmptyNoticeView];
    }
    else{
        [self kk_HideEmptyNoticeView];
    }
}

@end
