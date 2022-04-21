//
//  KKView.m
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import "KKView.h"
#import "KKUIToolbar.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"

@interface KKView ()<KKUIToolbarDelegate>

@property (nonatomic,weak)UIView *kk_beginEditeView;
@property (nonatomic,assign)CGFloat  kk_mainScrollOriginContentOffsetY;
@property (nonatomic,assign)CGSize  kk_mainScrollOriginContentSize;
@property (nonatomic,assign)CGFloat kk_keyboardHeightAlways;
@property (nonatomic,assign)CGFloat kk_keyboardAnimationTimeAlways;
@property (nonatomic,assign)CGFloat kk_keyboardHeight;
@property (nonatomic,assign)CGFloat kk_keyboardAnimationTime;
@property (nonatomic,assign)BOOL    kk_outAddKeyboardNotification;
@property (nonatomic,assign)BOOL    kk_haveAddKeyboardNotification;

@end

@implementation KKView
@synthesize endEditingWhenTouchBackground;

- (void)dealloc{
    [self unobserveAllNotification];
    [KKFileCacheManager deleteCacheDataInCacheDirectory:NSStringFromClass([self class])];
    [KKFileCacheManager deleteCacheDirectory:NSStringFromClass([self class])];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self observeThemeDidChangeNotification];
        [self observeLocalizationDidChangeNotification];
        endEditingWhenTouchBackground = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self observeThemeDidChangeNotification];
        [self observeLocalizationDidChangeNotification];
        endEditingWhenTouchBackground = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (endEditingWhenTouchBackground) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.kk_outAddKeyboardNotification) {
        [self addKeyboardNotificationFromOut:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.kk_outAddKeyboardNotification) {
        [self removeKeyboardNotificationFromOut:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillHidden:(BOOL)hidden{
    [super viewWillHidden:hidden];
    if (hidden) {
        if (self.kk_outAddKeyboardNotification) {
            [self removeKeyboardNotificationFromOut:NO];
        }
        [self endEditing:YES];
    }
    else{
        if (self.kk_outAddKeyboardNotification) {
            [self addKeyboardNotificationFromOut:NO];
        }
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGRect rect = [self convertRect:self.bounds toView:[UIWindow currentKeyWindow]];
    BOOL isInWindow = CGRectContainsRect([UIWindow currentKeyWindow].bounds, rect);
    if (isInWindow==NO) {
        if (self.kk_outAddKeyboardNotification) {
            [self removeKeyboardNotificationFromOut:NO];
        }
    }
    else{
        if (self.kk_outAddKeyboardNotification) {
            [self addKeyboardNotificationFromOut:NO];
        }
    }
}


#pragma mark ****************************************
#pragma mark 主题与多语言 监听
#pragma mark ****************************************
- (void)observeThemeDidChangeNotification {
    [self changeTheme];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme)  name:NotificationName_ThemeHasChanged object:nil];
}

- (void)unobserveThemeDidChangeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationName_ThemeHasChanged object:nil];
}

- (void)changeTheme {
    //在ViewController中重写
}

- (void)observeLocalizationDidChangeNotification {
    [self changeLocalization];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLocalization)  name:NotificationName_KKLocalizationDidChanged object:nil];
}

- (void)unobserveLocalizationDidChangeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationName_KKLocalizationDidChanged object:nil];
}

- (void)changeLocalization {
    //在ViewController中重写
}


#pragma mark ****************************************
#pragma mark Keyboard 监听
#pragma mark ****************************************
- (void)addKeyboardNotification{
    [self addKeyboardNotificationFromOut:YES];
}

/**
 监听键盘通知

 @param fromOut 是否是外部调用的监听键盘通知
 */
- (void)addKeyboardNotificationFromOut:(BOOL)fromOut{
    
    if (fromOut) {
        self.kk_outAddKeyboardNotification = YES;
    }
    
    if (self.kk_haveAddKeyboardNotification) {
        return;
    }
    
    CGRect rect = [self convertRect:self.bounds toView:[UIWindow currentKeyWindow]];
    BOOL isInWindow = CGRectContainsRect([UIWindow currentKeyWindow].bounds, rect);
    if (isInWindow==NO) {
        return;
    }
    
    self.kk_haveAddKeyboardNotification = YES;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //监听键盘高度的变换
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillShowNotification:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillHideNotification:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillChangeFrameNotification:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    
    //UITextField、UITextView
    [defaultCenter addObserver:self
                      selector:@selector(kk_textFieldViewDidBeginEditing:)
                          name:UITextFieldTextDidBeginEditingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(kk_textFieldViewDidEndEditing:)
                          name:UITextFieldTextDidEndEditingNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(kk_textFieldViewDidBeginEditing:)
                          name:UITextViewTextDidBeginEditingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(kk_textFieldViewDidEndEditing:)
                          name:UITextViewTextDidEndEditingNotification
                        object:nil];
}

- (void)removeKeyboardNotification{
    [self removeKeyboardNotificationFromOut:YES];
}

/**
 取消监听键盘通知
 
 @param fromOut 是否是外部调用的取消监听键盘通知
 */
- (void)removeKeyboardNotificationFromOut:(BOOL)fromOut{
    
    if (fromOut) {
        self.kk_outAddKeyboardNotification = NO;
    }
    
    if (self.kk_haveAddKeyboardNotification==NO) {
        return;
    }
    
    
    self.kk_haveAddKeyboardNotification = NO;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //监听键盘高度的变换
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillShowNotification object:nil];
    
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillHideNotification object:nil];
    
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //UITextField、UITextView
    [defaultCenter removeObserver:self
                             name:UITextFieldTextDidBeginEditingNotification
                           object:nil];
    
    [defaultCenter removeObserver:self
                             name:UITextFieldTextDidEndEditingNotification
                           object:nil];
    
    [defaultCenter removeObserver:self
                             name:UITextViewTextDidBeginEditingNotification
                           object:nil];
    
    [defaultCenter removeObserver:self
                             name:UITextViewTextDidEndEditingNotification
                           object:nil];    
}

- (void)kk_UIKeyboardWillShowNotification:(NSNotification*)aNotice{
    [self keyboardWillShow:aNotice];
}

- (void)kk_UIKeyboardWillChangeFrameNotification:(NSNotification*)aNotice{
    [self keyboardWillShow:aNotice];
}

- (void)kk_UIKeyboardWillHideNotification:(NSNotification*)aNotice{
    [self keyboardWillHide:aNotice];
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
    
    [self keyboardWillShowWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    
    self.kk_keyboardHeightAlways = keyBoardRect.size.height;
    self.kk_keyboardAnimationTimeAlways = animationDuration;
    
    if (_kk_beginEditeView==nil) {
        self.kk_keyboardHeight = keyBoardRect.size.height;
        self.kk_keyboardAnimationTime = animationDuration;
        return;
    }
    else{
        self.kk_keyboardHeight = 0;
        self.kk_keyboardAnimationTime = 0;
    }
    
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:_kk_beginEditeView];
    if (mainScrollView==nil) {
        return;
    }
    
    if (CGSizeEqualToSize(self.kk_mainScrollOriginContentSize, CGSizeZero)) {
        if (CGSizeEqualToSize(mainScrollView.contentSize, CGSizeZero)) {
            self.kk_mainScrollOriginContentSize = mainScrollView.frame.size;
        }
    }

    self.kk_mainScrollOriginContentOffsetY = mainScrollView.contentOffset.y;

    CGFloat selfViewHeight = self.frame.size.height;
    
    CGRect selfRectToWindow = [self convertRect:self.bounds toView:[UIWindow currentKeyWindow]];
    CGFloat selfBottonChaToWindow = [UIWindow currentKeyWindow].frame.size.height-selfRectToWindow.origin.y-selfRectToWindow.size.height;

    CGRect scrollViewRectToSelfView = [mainScrollView convertRect:mainScrollView.bounds toView:self];
    //本身键盘就没有挡住scrollView，更不可能挡住输入源，所以可以不用处理
    if (scrollViewRectToSelfView.origin.y+scrollViewRectToSelfView.size.height < (selfViewHeight-keyBoardRect.size.height-selfBottonChaToWindow)) {
        return;
    }
    
    //键盘弹出完全挡住了ScrollView本身，这时候随便怎么设置scrollView的contentOffset也无济于事
    if (scrollViewRectToSelfView.origin.y+scrollViewRectToSelfView.size.height < (selfViewHeight-keyBoardRect.size.height-selfBottonChaToWindow)) {
        return;
    }
    
    //本身键盘就没有挡住输入源，可以不用处理
    CGRect beginEditeViewRectToSelfView = [_kk_beginEditeView convertRect:_kk_beginEditeView.bounds toView:self];
    if (beginEditeViewRectToSelfView.origin.y+_kk_beginEditeView.frame.size.height<(selfViewHeight-keyBoardRect.size.height-selfBottonChaToWindow)) {
        return;
    }
    //键盘挡住了部分scrollView,但输入源刚好在没有挡住那部分，可以不用处理
    if ( beginEditeViewRectToSelfView.origin.y +  _kk_beginEditeView.frame.size.height + keyBoardRect.size.height-selfBottonChaToWindow-selfViewHeight<=0){
        return;
    }
    
    CGRect frame00 = [_kk_beginEditeView convertRect:_kk_beginEditeView.bounds toView:mainScrollView];

    CGFloat newContentOffsetY = scrollViewRectToSelfView.origin.y +
    frame00.origin.y +
    _kk_beginEditeView.frame.size.height +
    keyBoardRect.size.height-selfBottonChaToWindow -
    selfViewHeight+10;
    
    if (mainScrollView.contentOffset.y<newContentOffsetY) {
        [mainScrollView setContentOffset:CGPointMake(0, MAX(newContentOffsetY, 0)) animated:YES];
    }

    CGSize contentSize = self.kk_mainScrollOriginContentSize;
    contentSize.height = contentSize.height + self.kk_keyboardHeightAlways+10;
    mainScrollView.contentSize = contentSize;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardWillHideWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    
    if (self.kk_beginEditeView==nil) {
        return;
    }
    
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    if (mainScrollView==nil) {
        return;
    }

    mainScrollView.contentSize = self.kk_mainScrollOriginContentSize;

//    if (mainScrollView.contentOffset.y+mainScrollView.frame.size.height>mainScrollView.contentSize.height) {
//        CGFloat newContentOffsetY = MAX(mainScrollView.contentSize.height-mainScrollView.frame.size.height, 0);
//        [mainScrollView setContentOffset:CGPointMake(0, newContentOffsetY) animated:YES];
//    }
    
    [mainScrollView setContentOffset:CGPointMake(0, self.kk_mainScrollOriginContentOffsetY) animated:YES];

    self.kk_mainScrollOriginContentOffsetY = 0;
    self.kk_mainScrollOriginContentSize = CGSizeZero;
    self.kk_beginEditeView = nil;
}

- (void)kk_textFieldViewDidBeginEditing:(NSNotification*)aNotice{
    self.kk_beginEditeView = aNotice.object;
    
    if (self.kk_keyboardHeight>1) {
        [self keyboardWillShowWithAnimationDuration:self.kk_keyboardAnimationTime keyBoardRect:CGRectMake(0, 0, KKApplicationWidth, self.kk_keyboardHeight)];
    }

    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    if ([mainScrollView isKindOfClass:[UITableView class]]) {
        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_None delegate:self targetView:self.kk_beginEditeView];
    }
    else{
        NSMutableArray *array = [NSMutableArray array];
        for (UIView *subView in [mainScrollView subviews]) {
            if (([subView isKindOfClass:[UITextView class]] && [(UITextView*)subView isEditable]) ||
                ([subView isKindOfClass:[UITextField class]] && [(UITextField*)subView isUserInteractionEnabled]) ) {

                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                [dic setObject:subView forKey:@"view"];
                NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
                [dic setObject:frameKey forKey:@"frame"];
                
                [array addObject:dic];
            }
        }
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
        [array sortUsingDescriptors:sortDescriptors];
        
        if ([array count]<=1) {
            [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_None delegate:self targetView:self.kk_beginEditeView];
        }
        else{
            for (NSInteger i=0; i<[array count]; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                UIView *view = [dic objectForKey:@"view"];
                if (view==self.kk_beginEditeView) {
                    if (i==[array count]-1) {
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousYES_NextNO delegate:self targetView:self.kk_beginEditeView];
                    }
                    else if (i==0){
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousNO_NextYES delegate:self targetView:self.kk_beginEditeView];
                    }
                    else{
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousYES_NextYES delegate:self targetView:self.kk_beginEditeView];
                    }
                    break;
                }
            }
            
        }
    }
}

- (void)kk_textFieldViewDidEndEditing:(NSNotification*)aNotice{
    
}

- (void)KKUIToolbar_PreviousButtonClicked:(KKUIToolbar*)aToolbar{
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [mainScrollView subviews]) {
        if ([subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UITextField class]] ) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:subView forKey:@"view"];
            NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
            [dic setObject:frameKey forKey:@"frame"];
            
            [array addObject:dic];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    UIView *viewPrevious = nil;
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        UIView *view = [dic objectForKey:@"view"];
        if (view==self.kk_beginEditeView) {
            NSDictionary *dic0 = [array objectAtIndex:i-1];
            viewPrevious = [dic0 objectForKey:@"view"];
            [viewPrevious becomeFirstResponder];
            break;
        }
    }
}

- (void)KKUIToolbar_NextButtonClicked:(KKUIToolbar*)aToolbar{
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [mainScrollView subviews]) {
        if ([subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UITextField class]] ) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:subView forKey:@"view"];
            NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
            [dic setObject:frameKey forKey:@"frame"];
            
            [array addObject:dic];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    UIView *viewPrevious = nil;
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        UIView *view = [dic objectForKey:@"view"];
        if (view==self.kk_beginEditeView) {
            NSDictionary *dic0 = [array objectAtIndex:i+1];
            viewPrevious = [dic0 objectForKey:@"view"];
            [viewPrevious becomeFirstResponder];
            break;
        }
    }
}

- (void)KKUIToolbar_DoneButtonClicked:(KKUIToolbar*)aToolbar{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (UIScrollView*)kk_superScrollViewOfView:(UIView*)aView{
    
    UIScrollView *superScrollView = nil;
    
    UIView *superview = aView.superview;
    
    while (superview){
        if ([superview isKindOfClass:[UIScrollView class]])
        {
            superScrollView = (UIScrollView*)superview;
            break;
        }
        else{
            superview = superview.superview;
        }
    }
    return superScrollView;
}

@end
