//
//  KKCoreTextLabel.h
//  KKLibrary
//
//  Created by liubo on 13-5-11.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKCoreTextItem.h"

@protocol KKCoreTextLabelDelegate;

@interface KKCoreTextLabel : UILabel<UIGestureRecognizerDelegate>{
    
    __weak id<KKCoreTextLabelDelegate> _delegate;
    Class delegateClass;
}

@property(nonatomic,copy)NSString *originText;
@property(nonatomic,strong)UIColor *selectedBackgroundColor;
@property(nonatomic,strong)UIColor *normalBackgroundColor;
@property(nonatomic,assign)CGFloat rowSeparatorHeight;
@property(nonatomic,assign)BOOL  copyEnable;

@property(nonatomic,weak)id<KKCoreTextLabelDelegate> delegate;


@end


@protocol KKCoreTextLabelDelegate <NSObject>

@optional

- (void)KKCoreTextLabelSelectedItem:(KKCoreTextItem*)item;


@end






