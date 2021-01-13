//
//  KKTextEditViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/26.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKTextEditViewController.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"

@interface KKTextEditViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic , strong) KKTextEditViewStyle *myStyle;

@property (nonatomic,strong)UIView *backView;

@end

@implementation KKTextEditViewController

- (instancetype)initWithStyle:(KKTextEditViewStyle*)aStyle{
    self = [super init];
    if (self) {
        self.myStyle = aStyle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.myStyle.title;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self showNavigationDefaultBackButton_ForNavPopBack];
    [self setNavRightButtonTitle:KKLibLocalizable_Common_Save titleColor:[UIColor colorWithHexString:@"#1296DB"] selector:@selector(finishedEdit)];

    CGFloat offsetY = 0;
    if ([NSString isStringNotEmpty:self.myStyle.subTitle]) {
        UILabel *subLabel = [UILabel kk_initWithTextColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12] text:self.myStyle.subTitle lines:0 maxWidth:KKScreenWidth-20];
        subLabel.frame = CGRectMake(10, 15, KKScreenWidth-20, subLabel.height);
        [self.view addSubview:subLabel];
        offsetY = offsetY + 15 + subLabel.height + 15;
    }

    if (self.type==TextEditType_TextFeild) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(-10, offsetY, KKApplicationWidth+20, 50)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setBorderColor:[UIColor colorWithHexString:@"#DEDEDE"] width:0.5];
        [self.view addSubview:self.backView];
        
        [self observeNotification:UITextFieldTextDidChangeNotification selector:@selector(UITextFieldTextDidChangeNotification:)];
        
        self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.backView.top, KKApplicationWidth-30, self.backView.height)];
        self.myTextField.backgroundColor = [UIColor clearColor];
        self.myTextField.font = [UIFont systemFontOfSize:16];
        self.myTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.myTextField.placeholder = self.myStyle.placeHoleder;
        self.myTextField.returnKeyType = UIReturnKeyDone;
        self.myTextField.enabled = YES;
        self.myTextField.delegate = self;
        [self.view addSubview:self.myTextField];
        self.myTextField.text = self.myStyle.inText;
        
        if (self.myStyle.isNumber) {
            if ([self.myStyle.inText floatValue]==0) {
                self.myTextField.text = @"";
            }
            self.myTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        if (self.myStyle.maxLenth>0) {
            //限制字数
            self.maxLenthLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-30, 20)];
            [self.maxLenthLabel clearBackgroundColor];
            self.maxLenthLabel.textColor = [UIColor lightGrayColor];
            self.maxLenthLabel.textAlignment = NSTextAlignmentRight;
            self.maxLenthLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:self.maxLenthLabel];
            self.maxLenthLabel.hidden = self.myStyle.hideLimitedText;
        }
        [self checkMaxLenth];
    }
    else{
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(-10, offsetY, KKApplicationWidth+20, 120)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setBorderColor:[UIColor colorWithHexString:@"#DEDEDE"] width:0.5];
        [self.view addSubview:self.backView];
        
        [self observeNotification:UITextViewTextDidChangeNotification selector:@selector(UITextViewTextDidChangeNotification:)];
        
        self.myTextView = [[KKTextView alloc]initWithFrame:CGRectMake(10, self.backView.top+10, KKApplicationWidth-20, 110)];
        self.myTextView.delegate = self;
        [self.myTextView clearBackgroundColor];
        self.myTextView.placeholder = self.myStyle.placeHoleder;
        self.myTextView.editable = YES;
        self.myTextView.selectable = YES;
        self.myTextView.font = [UIFont systemFontOfSize:16];
        [self.myTextView setContentInset:UIEdgeInsetsMake(-3, 5, -3, -10)];//设置UITextView的内边距
        [self.view addSubview:self.myTextView];
        self.myTextView.text = self.myStyle.inText;
        
        if (self.myStyle.isSingleLine) {
            self.myTextView.returnKeyType = UIReturnKeyDone;
        }
        else{
            self.myTextView.returnKeyType = UIReturnKeyDefault;
        }
        
        if (self.myStyle.maxLenth>0) {
            //限制字数
            self.maxLenthLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-30, 20)];
            [self.maxLenthLabel clearBackgroundColor];
            self.maxLenthLabel.textColor = [UIColor lightGrayColor];
            self.maxLenthLabel.textAlignment = NSTextAlignmentRight;
            self.maxLenthLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:self.maxLenthLabel];
            self.maxLenthLabel.hidden = self.myStyle.hideLimitedText;
        }
        
        [self checkMaxLenth];
    }
    
}

- (void)navigationControllerPopBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishedEdit{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKTextEditViewController:shouldReturnWithText:style:)]) {
        BOOL shouldReturn = NO;
        if (self.myStyle.type==TextEditType_TextFeild) {
            shouldReturn = [self.delegate KKTextEditViewController:self shouldReturnWithText:self.myTextField.text style:self.myStyle];
        }
        else{
            shouldReturn = [self.delegate KKTextEditViewController:self shouldReturnWithText:self.myTextView.text style:self.myStyle];
        }
        
        if (shouldReturn) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)checkMaxLenth{
    if (self.myStyle.engCharacterHalfLenth) {
        [self checkMaxLenthForEnglishHalf];
    }
    else{
        [self checkMaxLenthForDefault];
    }
}

- (void)checkMaxLenthForDefault{
    if (self.myStyle.maxLenth>0) {
        
        if (self.myTextField) {
            
            UITextRange *selectedRange = [self.myTextField markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [self.myTextField.text length];
                
                if ( textLenth > self.myStyle.maxLenth ) {
                    self.myTextField.text = [self.myTextField.text substringToIndex:self.myStyle.maxLenth];
                }
                textLenth = [self.myTextField.text length];
                NSUInteger shengLenth = (unsigned long)(self.myStyle.maxLenth-textLenth);
                self.maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
            
            //            //获取高亮部分
            //            UITextPosition *position = [myTextField positionFromPosition:selectedRange.start offset:0];
            //
            //            if ( !position ) {
            //                NSUInteger textLenth = [myTextField.text length];
            //
            //                if ( textLenth > maxLenth ) {
            //                    myTextField.text = [myTextField.text substringToIndex:maxLenth];
            //                }
            //                textLenth = [myTextField.text length];
            //                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
            //                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            //            }
        }
        else if (self.myTextView){
            UITextRange *selectedRange = [self.myTextView markedTextRange];
            if ([selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [self.myTextView.text length];
                
                if ( textLenth > self.myStyle.maxLenth ) {
                    self.myTextView.text = [self.myTextView.text substringToIndex:self.myStyle.maxLenth];
                }
                textLenth = [self.myTextView.text length];
                NSUInteger shengLenth = (unsigned long)(self.myStyle.maxLenth-textLenth);
                self.maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
            //            //获取高亮部分
            //            UITextPosition *position = [myTextView positionFromPosition:selectedRange.start offset:0];
            //
            //            if ( !position ) {
            //                NSUInteger textLenth = [myTextView.text length];
            //
            //                if ( textLenth > maxLenth ) {
            //                    myTextView.text = [myTextView.text substringToIndex:maxLenth];
            //                }
            //                textLenth = [myTextView.text length];
            //                NSUInteger shengLenth = (unsigned long)(maxLenth-textLenth);
            //                maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            //            }
        }
        else{
            
        }
    }
}

- (void)checkMaxLenthForEnglishHalf{
    if (self.myStyle.maxLenth>0) {
        
        if (self.myTextField) {
            
            UITextRange *selectedRange = [self.myTextField markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [self.myTextField.text realLenth];
                
                if ( textLenth > self.myStyle.maxLenth ) {
                    NSString *tempString = nil;
                    for (NSInteger i=0; i<[self.myTextField.text length]; i++) {
                        tempString = [self.myTextField.text substringToIndex:i];
                        if ([tempString realLenth]>self.myStyle.maxLenth) {
                            tempString = [self.myTextField.text substringToIndex:i-1];
                            break;
                        }
                    }
                    self.myTextField.text = tempString;
                }
                
                textLenth = [self.myTextField.text realLenth];
                NSUInteger shengLenth = (unsigned long)(self.myStyle.maxLenth-textLenth);
                self.maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
        }
        else if (self.myTextView){
            UITextRange *selectedRange = [self.myTextView markedTextRange];
            if ( [selectedRange isEmpty] || selectedRange==nil) {
                NSUInteger textLenth = [self.myTextView.text realLenth];
                
                if ( textLenth > self.myStyle.maxLenth ) {
                    NSString *tempString = nil;
                    for (NSInteger i=0; i<[self.myTextView.text length]; i++) {
                        tempString = [self.myTextView.text substringToIndex:i];
                        if ([tempString realLenth]>self.myStyle.maxLenth) {
                            tempString = [self.myTextView.text substringToIndex:i-1];
                            break;
                        }
                    }
                    self.myTextView.text = tempString;
                }
                
                textLenth = [self.myTextView.text realLenth];
                NSUInteger shengLenth = (unsigned long)(self.myStyle.maxLenth-textLenth);
                self.maxLenthLabel.text = [NSString stringWithFormat:@"还剩%ld个字",(long)shengLenth];
            }
        }
        else{
            
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
    if (self.myTextField) {
        [self.myTextField becomeFirstResponder];
    }
    if (self.myTextView) {
        [self.myTextView becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
    if (self.myTextField) {
        [self.myTextField resignFirstResponder];
    }
    if (self.myTextView) {
        [self.myTextView resignFirstResponder];
    }
}

#pragma mark ****************************************
#pragma mark Keyboard 监听
#pragma mark ****************************************
- (void)addKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
    if ([UIDevice isSystemVersionBigerThan:@"5.0"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)removeKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    if ([UIDevice isSystemVersionBigerThan:@"5.0"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    keyboradAnimationDuration = animationDuration;//键盘两种高度 216  252
    
    if (self.type==TextEditType_TextFeild) {
        self.backView.frame = CGRectMake(-10, self.backView.frame.origin.y, KKApplicationWidth+20, MIN(KKScreenHeight-20-keyboardRect.size.height, 50));
        self.myTextField.frame = CGRectMake(10, self.backView.frame.origin.y, KKApplicationWidth-20, self.backView.frame.size.height);
        
        if (self.myStyle.maxLenth>0) {
            //限制字数
            self.maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-20, 20);
        }
    }
    else{
        if (self.myStyle.maxLenth>0) {
            CGFloat maxHeight = KKScreenHeight-KKStatusBarAndNavBarHeight-keyboardRect.size.height-20 - 20;
            self.backView.frame = CGRectMake(-10, self.backView.frame.origin.y, KKApplicationWidth+20, maxHeight);
            self.myTextView.frame = CGRectMake(10, self.backView.frame.origin.y+10, KKApplicationWidth-20, self.backView.frame.size.height-10);
            
            //限制字数
            self.maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-20, 20);
        }
        else{
            CGFloat maxHeight = KKScreenHeight-KKStatusBarAndNavBarHeight-keyboardRect.size.height - 20;
            self.backView.frame = CGRectMake(-10, self.backView.frame.origin.y, KKApplicationWidth+20, maxHeight);
            self.myTextView.frame = CGRectMake(10, self.backView.frame.origin.y+10, KKApplicationWidth-20, self.backView.frame.size.height-10);
            self.maxLenthLabel.frame = CGRectZero;
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    if (self.type==TextEditType_TextFeild) {
        self.backView.frame = CGRectMake(-10, self.backView.frame.origin.y, KKApplicationWidth+20, 50);
        self.myTextField.frame = CGRectMake(10, self.backView.frame.origin.y, KKApplicationWidth-20, self.backView.frame.size.height);
        
        if (self.myStyle.maxLenth>0) {
            //限制字数
            self.maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-20, 20);
        }
    }
    else{
        self.backView.frame = CGRectMake(-10, self.backView.frame.origin.y, KKApplicationWidth+20, 120);
        self.myTextView.frame = CGRectMake(10, self.backView.frame.origin.y+10, KKApplicationWidth-20, self.backView.frame.size.height-10);
        
        if (self.myStyle.maxLenth>0) {
            //限制字数
            self.maxLenthLabel.frame = CGRectMake(10, CGRectGetMaxY(self.backView.frame), KKApplicationWidth-20, 20);
        }
    }
}

#pragma mark ****************************************
#pragma mark 【UITextFieldDelegate】
#pragma mark ****************************************
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.canShowThirdKeyBorad = YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self checkMaxLenth];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self finishedEdit];
    return YES;
}

- (void)UITextFieldTextDidChangeNotification:(NSNotification*)notice{
    [self checkMaxLenth];
}

#pragma mark ****************************************
#pragma mark 【UITextViewDelegate】
#pragma mark ****************************************
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (self.myStyle.isSingleLine && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else{
        [self checkMaxLenth];
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
}

- (void)UITextViewTextDidChangeNotification:(NSNotification*)notice{
    [self checkMaxLenth];
}


@end
