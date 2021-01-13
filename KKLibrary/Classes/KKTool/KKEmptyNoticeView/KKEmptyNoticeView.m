//
//  KKEmptyNoticeView.m
//  GouUseCore
//
//  Created by beartech on 2017/8/10.
//  Copyright © 2017年 gouuse. All rights reserved.
//

#import "KKEmptyNoticeView.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"

@implementation KKEmptyNoticeView

+ (KKEmptyNoticeView*)showInView:(UIView*)aView
                       withImage:(UIImage*)aImage
                        delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate{
    
    return [KKEmptyNoticeView showInView:aView
                               withImage:aImage
                                    text:nil
                             buttonTitle:nil
                               alignment:KKEmptyNoticeViewAlignment_Center
                                delegate:aDelegate];
}

+ (KKEmptyNoticeView*)showInView:(UIView*)aView
                       withImage:(UIImage*)aImage
                            text:(NSString*)aText
                     buttonTitle:(NSString*)aButtonTitle
                       alignment:(KKEmptyNoticeViewAlignment)alignment
                        delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate{

    [KKEmptyNoticeView hideForView:aView];
    
    KKEmptyNoticeView *subView = [[KKEmptyNoticeView alloc] initWithFrame:aView.bounds
                                                                withImage:aImage
                                                                     text:aText
                                                              buttonTitle:aButtonTitle
                                                                alignment:alignment
                                                                 delegate:aDelegate];
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    
    return subView;
}

+ (void)hideForView:(UIView*)aView{
    for (UIView *subView in [aView subviews]) {
        if ([subView isKindOfClass:[KKEmptyNoticeView class]]) {
            [subView removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                    withImage:(UIImage*)aImage
                         text:(NSString*)aText
                  buttonTitle:(NSString*)aButtonTitle
                    alignment:(KKEmptyNoticeViewAlignment)alignment
                     delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = aDelegate;

        CGSize imageSize = aImage.size;
        if (aImage.size.width>frame.size.width) {
            CGFloat width = frame.size.width;
            CGFloat height = (width * aImage.size.height)/(aImage.size.width);
            imageSize = CGSizeMake(width, height);
        }
        
        UIFont *textFont = [UIFont systemFontOfSize:16];
        UIColor *textColor = [UIColor colorWithHexString:@"#8899A9"];
        CGFloat spaceBetween_imagetext = 24;
        CGFloat spaceBetween_textbutton = 8;
        CGFloat button_height = 38;
        CGSize textSize = [aText sizeWithFont:textFont
                                      maxSize:CGSizeMake(self.bounds.size.width-30, 10000)];
        CGFloat Y = 0;
        if (alignment==KKEmptyNoticeViewAlignment_Top) {
            Y = 40;
        }
        else if (alignment==KKEmptyNoticeViewAlignment_Center) {
            if ([NSString isStringEmpty:aButtonTitle]) {
                spaceBetween_textbutton = 0;
                Y = (self.bounds.size.height-imageSize.height-spaceBetween_imagetext-textSize.height)/2.0;
            }
            else{
                Y = (self.bounds.size.height-imageSize.height-spaceBetween_imagetext-textSize.height-spaceBetween_textbutton-button_height)/2.0;
            }
        }
        else{

        }
        
        if (aImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-imageSize.width)/2.0, Y, imageSize.width, imageSize.height)];
            imageView.image = aImage;
            [self addSubview:imageView];
            Y = Y + imageSize.height;
            
            Y = Y + spaceBetween_imagetext;
            
            UIButton *buton = [[UIButton alloc] initWithFrame:imageView.frame];
            buton.backgroundColor = [UIColor clearColor];
            [buton addTarget:self action:@selector(imageClicked) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buton];
        }
        
        if ([NSString isStringNotEmpty:aText]) {
            self.vTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, Y, self.bounds.size.width-30, textSize.height)];
            self.vTitleLabel.text = aText;
            self.vTitleLabel.textAlignment = NSTextAlignmentCenter;
            self.vTitleLabel.numberOfLines = 0;
            self.vTitleLabel.textColor = textColor;
            self.vTitleLabel.font = textFont;
            [self addSubview:self.vTitleLabel];
            Y = Y + textSize.height;
            
            UIButton *buton = [[UIButton alloc] initWithFrame:self.vTitleLabel.frame];
            buton.backgroundColor = [UIColor clearColor];
            [buton addTarget:self action:@selector(labelClicked) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buton];
        }
        
        Y = Y + spaceBetween_textbutton;
        if ([NSString isStringNotEmpty:aButtonTitle]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width-97)/2.0, Y, 97, button_height)];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [button setTitle:aButtonTitle forState:UIControlStateNormal];
            [button setCornerRadius:5];
            [button setBorderColor:[UIColor blueColor] width:1.0];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }

    }
    return self;
}

- (void)labelClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKEmptyNoticeView_TextClicked:)]) {
        [self.delegate KKEmptyNoticeView_TextClicked:self];
    }
}

- (void)imageClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKEmptyNoticeView_ImageClicked:)]) {
        [self.delegate KKEmptyNoticeView_ImageClicked:self];
    }
}

- (void)buttonClicked:(UIButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKEmptyNoticeView_ButtonClicked:)]) {
        [self.delegate KKEmptyNoticeView_ButtonClicked:self];
    }
}

@end


//#pragma ==================================================
//#pragma == UITableView_KKEmptyNoticeView
//#pragma ==================================================
//@implementation UITableView (UITableView_KKEmptyNoticeView)
//
//- (void)showEmptyViewWithImage:(UIImage*)aImage
//                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate{
//
//    [self showEmptyViewWithImage:aImage text:nil
//                     buttonTitle:nil
//                       alignment:KKEmptyNoticeViewAlignment_Center
//                        delegate:aDelegate
//                         offsetY:0];
//}
//
//- (void)showEmptyViewWithImage:(UIImage*)aImage
//                          text:(NSString*)text
//                   buttonTitle:(NSString*)aButtonTitle
//                     alignment:(KKEmptyNoticeViewAlignment)alignment
//                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate
//                       offsetY:(CGFloat)offsetY{
//
//    UIView *fullView = [[UIView alloc] initWithFrame:self.bounds];
//    [fullView clearBackgroundColor];
//
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, fullView.frame.size.width, fullView.frame.size.height-offsetY)];
//    backgroundView.backgroundColor = [UIColor clearColor];
//    [fullView addSubview:backgroundView];
//    [KKEmptyNoticeView showInView:backgroundView
//                        withImage:aImage
//                             text:text
//                      buttonTitle:aButtonTitle
//                        alignment:alignment
//                         delegate:aDelegate];
//
//    self.backgroundView = fullView;
//
//    self.hidden = NO;
//
//    [self reloadData];
//}
//
//- (void)hideEmptyViewWithBackgroundColor:(UIColor*)aColor{
//    if (aColor) {
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        backgroundView.backgroundColor = aColor;
//        self.backgroundView = backgroundView;
//    }
//    else{
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundView = backgroundView;
//    }
//}
//
//@end
//
//
//#pragma ==================================================
//#pragma == UICollectionView_KKEmptyNoticeView
//#pragma ==================================================
//@implementation UICollectionView (UICollectionView_KKEmptyNoticeView)
//
//- (void)showEmptyViewWithImage:(UIImage*)aImage
//                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate{
//
//    [self showEmptyViewWithImage:aImage text:nil
//                     buttonTitle:nil
//                       alignment:KKEmptyNoticeViewAlignment_Center
//                        delegate:aDelegate
//                         offsetY:0];
//}
//
//- (void)showEmptyViewWithImage:(UIImage*)aImage
//                          text:(NSString*)text
//                   buttonTitle:(NSString*)aButtonTitle
//                     alignment:(KKEmptyNoticeViewAlignment)alignment
//                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate
//                       offsetY:(CGFloat)offsetY{
//
//    UIView *fullView = [[UIView alloc] initWithFrame:self.bounds];
//    fullView.backgroundColor = [UIColor clearColor];
//
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, fullView.frame.size.width, fullView.frame.size.height-offsetY)];
//    backgroundView.backgroundColor = [UIColor clearColor];
//    [fullView addSubview:backgroundView];
//    [KKEmptyNoticeView showInView:backgroundView
//                        withImage:aImage
//                             text:text
//                      buttonTitle:aButtonTitle
//                        alignment:alignment
//                         delegate:aDelegate];
//
//    self.backgroundView = fullView;
//
//    self.hidden = NO;
//
//    [self reloadData];
//}
//
//- (void)hideEmptyViewWithBackgroundColor:(UIColor*)aColor{
//    if (aColor) {
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        backgroundView.backgroundColor = aColor;
//        self.backgroundView = backgroundView;
//    }
//    else{
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
//        backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundView = backgroundView;
//    }
//}
//
//
//
//@end
