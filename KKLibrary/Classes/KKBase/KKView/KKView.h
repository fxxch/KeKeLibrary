//
//  KKView.h
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKView : UIView{
    BOOL endEditingWhenTouchBackground;
}

@property (nonatomic,assign)BOOL endEditingWhenTouchBackground;

#pragma mark ==================================================
#pragma mark == 主题与本地化
#pragma mark ==================================================
- (void)changeTheme;

- (void)changeLocalization;

- (void)addKeyboardNotification;

- (void)removeKeyboardNotification;

- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;

- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;

@end
