//
//  KKTextView.h
//  Demo
//
//  Created by liubo on 13-9-4.
//  Copyright (c) 2013年 liubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTextView : UITextView {
    NSInteger _maxLength;
}

@property (nonatomic, strong) UILabel  *placeHolderLabel;
@property (nonatomic, copy)   NSString *placeholder;
@property (nonatomic, copy)   NSAttributedString *attributedPlaceholder;
@property (nonatomic, copy)   UIColor  *placeholderColor;
@property (nonatomic,assign)  NSInteger maxLength;
@property (nonatomic,assign)  UIEdgeInsets placeHolderLabelEdgeInsets;



-(void)textChanged:(NSNotification*)notification;

@end

