//
//  KKEmoticonView.m
//  TTT
//
//  Created by liubo on 13-12-25.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKEmoticonView.h"
#import "KKCategory.h"
#import <objc/runtime.h>

#define  KKEmoticonView_ShowingView_Tag 20140321


@implementation KKEmoticonViewCacheManager

+ (KKEmoticonViewCacheManager *)defaultManager {
    static KKEmoticonViewCacheManager *KKEmoticonViewCacheManager_defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKEmoticonViewCacheManager_defaultManager = [[self alloc] init];
    });
    return KKEmoticonViewCacheManager_defaultManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.emotionDataCache = [[NSMutableDictionary alloc] init];
        self.emotionsAll = [[NSMutableArray alloc] init];
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *emotionPlistPath = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/emoji.plist", bundlePath];
        NSArray *emotionsAll_Temp = [NSArray arrayWithContentsOfFile:emotionPlistPath];
        [self.emotionsAll addObjectsFromArray:emotionsAll_Temp];
        [self observeNotificaiton:UIApplicationDidReceiveMemoryWarningNotification selector:@selector(ApplicationDidReceiveMemoryWarningNotification:)];
    }
    return self;
}

- (void)ApplicationDidReceiveMemoryWarningNotification:(NSNotification*)aNotice{
    [self.emotionDataCache removeAllObjects];
}

- (NSData*)readDataForKey:(NSString*)aKey{
   return [[[KKEmoticonViewCacheManager defaultManager] emotionDataCache] objectForKey:aKey];
}

- (void)saveData:(NSData*)aData forKey:(NSString*)aKey{
    if (aData && [aData isKindOfClass:[NSData class]] &&
        [NSString isStringNotEmpty:aKey]) {
        [[[KKEmoticonViewCacheManager defaultManager] emotionDataCache] setObject:aData forKey:aKey];
    }
}

@end


@implementation KKEmoticonView
@synthesize delegate = myDelegate;

- (void)dealloc {
    
    self.pageControl = nil;
    self.myPageView = nil;
    self.tabBarView = nil;
    self.selectedItems = nil;

    [self unobserveAllNotification];
}

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
+ (void)showWithTarget:(id)aTarget delegate:(id<KKEmojiViewDelegate>)aDelegate{
    [self showWithTarget:aTarget delegate:aDelegate showSendButton:NO];
}

+ (void)showWithTarget:(id)aTarget delegate:(id<KKEmojiViewDelegate>)aDelegate showSendButton:(BOOL)showSendButton{
    
    KKEmoticonView *emotionView = [[KKEmoticonView alloc] initWithTarget:aTarget delegate:aDelegate showSendButton:showSendButton];
    
    if ([aTarget isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)aTarget;
        [textView resignFirstResponder];
        [textView setInputView:emotionView];
        [textView becomeFirstResponder];
    }
}

- (id)initWithTarget:(id)aTarget delegate:(id<KKEmojiViewDelegate>)aDelegate showSendButton:(BOOL)showSendButton{
    if (self = [super init]) {
        self.target = aTarget;
        [self setDelegate:aDelegate];
        self.shouldShowSendButton = showSendButton;
        self.selectedItems = [[NSMutableArray alloc] init];
        [self initSubViews];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.87f alpha:1.00f];
        [self addSubview:view];

        [self observeNotificaiton:UITextViewTextDidChangeNotification selector:@selector(TextViewTextDidChangeNotification:)];
        
    }
    return self;
}

- (void)setDelegate:(id<KKEmojiViewDelegate>)delegate{
    myDelegate = delegate;
    delegateClass = object_getClass(myDelegate);
}

- (void)TextViewTextDidChangeNotification:(NSNotification*)notice{
    if ([notice.object isEqual:self.target]) {
        UITextView *myTextView = (UITextView*)self.target;
        if (myTextView && [myTextView isKindOfClass:[UITextView class]]) {
            UIButton *button = (UIButton*)[self viewWithTag:20151212];

            if ([NSString isStringNotEmpty:myTextView.text]) {
                [button setBackgroundColor:[UIColor blueColor]];
                [button setBorderColor:[UIColor whiteColor] width:0.5];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundColor:[UIColor clearColor]];
                [button setBorderColor:[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.0] width:0.5];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)initSubViews {
    
    UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(window.bounds), KKEmojiViewHeight)];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //表情界面
    self.myPageView = [[KKPageScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, KKEmojiViewHeight-KKEmojiViewTabBarHeight-KKEmojiViewPageControlHeight)];
    self.myPageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    self.myPageView.delegate = self;
    [self addSubview:self.myPageView];
    
    //PageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.myPageView.frame),
                                                                   self.frame.size.width,
                                                                   KKEmojiViewPageControlHeight)];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.88f green:0.87f blue:0.87f alpha:1.00f];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.76f green:0.76f blue:0.76f alpha:1.00f];
    self.pageControl.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self.pageControl setHidesForSinglePage:YES];
    [self addSubview:self.pageControl];
    
    
    //下面的TabBar
    [self loadTabView];
}

- (void)loadTabView {
    
    self.tabBarView = [[UIScrollView alloc] init];
    self.tabBarView.userInteractionEnabled = YES;
    [self.tabBarView setPagingEnabled:NO];
    [self.tabBarView setShowsHorizontalScrollIndicator:NO];
    [self.tabBarView setShowsVerticalScrollIndicator:NO];
    [self.tabBarView setBounces:NO];
    [self.tabBarView setBackgroundColor:[UIColor whiteColor]];
    [self.tabBarView setClipsToBounds:NO];
    [self addSubview:self.tabBarView];
    if (self.shouldShowSendButton) {
        self.tabBarView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.pageControl.frame),
                                      self.frame.size.width-60,
                                      KKEmojiViewTabBarHeight);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor blueColor]];
//        [button setBorderColor:[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.0] width:0.5];
        [button setFrame:CGRectMake(self.frame.size.width-50, CGRectGetMinY(self.tabBarView.frame), 50, self.tabBarView.frame.size.height)];
        button.tag = 20151212;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitle:@"发送" forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        UITextView *myTextView = (UITextView*)self.target;
        if (myTextView && [myTextView isKindOfClass:[UITextView class]]) {
            if ([NSString isStringNotEmpty:myTextView.text]) {
                [button setBackgroundColor:[UIColor blueColor]];
                [button setBorderColor:[UIColor whiteColor] width:0.5];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
                [button setBackgroundColor:[UIColor clearColor]];
                [button setBorderColor:[UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.0] width:0.5];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    else{
        self.tabBarView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.pageControl.frame),
                                      CGRectGetWidth(self.bounds),
                                      KKEmojiViewTabBarHeight);
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    line.clipsToBounds = NO;
    [self.tabBarView addSubview:line];
    
    NSArray *emotionsAll = [KKEmoticonView emotionPlistArray];
    
    CGFloat width = 60;
    CGFloat height = CGRectGetHeight(self.tabBarView.bounds);
    for (int i=0; i<[emotionsAll count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [button setTag:i];
        NSDictionary *dic = [emotionsAll objectAtIndex:i];
        NSDictionary *info = [dic validDictionaryForKey:@"info"];
        NSString *filepath01 = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/%@", [[NSBundle mainBundle] bundlePath],[info validStringForKey:@"normal"]];
        UIImage *image01 = [UIImage imageWithContentsOfFile:filepath01];
        [button setImage:image01 forState:UIControlStateNormal];
        NSString *filepath02 = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/%@", [[NSBundle mainBundle] bundlePath],[info validStringForKey:@"pressed"]];
        UIImage *image02 = [UIImage imageWithContentsOfFile:filepath02];
        [button setImage:image02 forState:UIControlStateSelected];
        [button setFrame:CGRectMake(i*width, 0, width, height)];
        
        [button addTarget:self
                   action:@selector(categoryButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        if (i!=[emotionsAll count]-1) {
            UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width-0.5, 5, 0.5, button.frame.size.height-10)];
            line0.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
            [button addSubview:line0];
        }
        
        [self.tabBarView addSubview:button];
        
        if (i==0) {
            button.selected = YES;
            [self categoryButtonAction:button];
        }
        [self.tabBarView setContentSize:CGSizeMake(CGRectGetMaxX(button.frame), height)];
    }
}

#pragma mark ==================================================
#pragma mark == 事件
#pragma mark ==================================================
- (void)categoryButtonAction:(UIButton *)sender {
    
    if (self.selectedTabBarButton == sender) {
        return ;
    }
    
    if (self.selectedTabBarButton) {
        [self.selectedTabBarButton setBackgroundColor:[UIColor clearColor]];
        [self.selectedTabBarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    }
    
    self.selectedTabBarButton = sender;
    [self.selectedTabBarButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    [self.selectedTabBarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];

    self.currentGroupIndex = self.selectedTabBarButton.tag;
    [self.myPageView showPageIndex:0 animated:NO];
}

- (void)sendButtonAction{
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonViewDidSelectedSend)]) {
        [myDelegate emoticonViewDidSelectedSend];
    }
}

- (void)emojiButtonAction:(UIButton *)sender {
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonView:didSelectedItem:)]) {
        NSArray *emotionsAll = [KKEmoticonView emotionPlistArray];
        NSDictionary *currentGroup = [emotionsAll objectAtIndex:self.currentGroupIndex];
        NSArray *emotions = [currentGroup objectForKey:@"data"];
        [_delegate emoticonView:self didSelectedItem:[emotions objectAtIndex:sender.tag]];
        [self.selectedItems addObject:[emotions objectAtIndex:sender.tag]];
    }
}

- (void)deleteLastItem {
    NSString *text = @"";
    if ([self.target isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)self.target;
        text = [textView text];
        NSDictionary *item = [self.selectedItems lastObject];
        if (item != nil) {
            NSString *title = [item objectForKey:kEmoticonGroupShowName];
            if (title !=nil && [text hasSuffix:title]) {
                text = [text substringToIndex:text.length-title.length];
                [textView setText:text];
                [self.selectedItems removeLastObject];
                
                Class currentClass = object_getClass(myDelegate);
                if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonViewDidDeleteLastEmotionItem:)]) {
                    [myDelegate emoticonViewDidDeleteLastEmotionItem:title];
                }
            }
            else {
                Class currentClass = object_getClass(myDelegate);
                if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonViewDidSelectedBackward)]) {
                    [myDelegate emoticonViewDidSelectedBackward];
                }
                else{
                    [textView deleteBackward];
                }
            }
        }
        else {
            Class currentClass = object_getClass(myDelegate);
            if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonViewDidSelectedBackward)]) {
                [myDelegate emoticonViewDidSelectedBackward];
            }
            else{
                [textView deleteBackward];
            }
        }
    }
    
}


#pragma mark ==================================================
#pragma mark == KKPageScrollViewDelegate
#pragma mark ==================================================
- (UIView*)pageView:(KKPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    
    UIView *page = [pageView viewForPageIndex:pageIndex];
    if (page==nil) {
        page = [[UIView alloc]init];
        page.userInteractionEnabled = YES;
        page.backgroundColor = [UIColor clearColor];
    }
    page.frame = self.myPageView.bounds;
        
    for (UIView *subView in [page subviews]) {
        [subView removeFromSuperview];
    }
    
    NSArray *emotionsAll = [KKEmoticonView emotionPlistArray];
    NSDictionary *currentGroup = [emotionsAll objectAtIndex:self.currentGroupIndex];
    NSArray *emotions = [currentGroup objectForKey:@"data"];
    
    float width = 35.0f;//表情大小35
    float height = 35.0f; //表情大小35
    CGFloat space = 10; //表情之间间隙10
    //每一行的表情个数
    NSInteger countPerRow = (NSInteger)((self.frame.size.width-space)/(40+space));
    space = (self.frame.size.width - (countPerRow*width))/(countPerRow+1);
    
    int count = (int)emotions.count;
    //当前页面能放多少个表情（有可能放不满的情况）
    int nowPageCount = (int)MIN(count-pageIndex*(countPerRow*4-1)+1, countPerRow*4);

    
    CGFloat X = space;
    CGFloat Y = 5;
    for (int i=0; i<nowPageCount; i++) {
        
        CGRect frame = CGRectMake(X, Y, width, height);
        
        if (i==nowPageCount-1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *filepath01 = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/emoji_del_normal", [[NSBundle mainBundle] bundlePath]];
            UIImage *image01 = [UIImage imageWithContentsOfFile:filepath01];
            NSString *filepath02 = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/emoji_del_pressed", [[NSBundle mainBundle] bundlePath]];
            UIImage *image02 = [UIImage imageWithContentsOfFile:filepath02];

            [button setImage:image01 forState:UIControlStateNormal];
            [button setImage:image02 forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(deleteLastItem) forControlEvents:UIControlEventTouchUpInside];
            button.frame = frame;
            [page addSubview:button];
        }
        else{
            NSInteger subIndex = i + pageIndex*(countPerRow*4-1);
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setTag:subIndex];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = YES;
            [imageView showImageData:[KKEmoticonView emotionData_OfGroupIndex:self.currentGroupIndex subIndex:subIndex] inFrame:frame];
            [page addSubview:imageView];
            
            // 单击的 Recognizer
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            tapGestureRecognizer.delegate = self;
            tapGestureRecognizer.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:tapGestureRecognizer];
            
            // 添加长按手势
            UILongPressGestureRecognizer *longPressGesture =
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMessage:)];
            [longPressGesture setDelegate:self];
            [longPressGesture setMinimumPressDuration:0.5f];
            [longPressGesture setAllowableMovement:0.0];
            [imageView addGestureRecognizer:longPressGesture];
        }
    
        if ((i+1)%countPerRow==0 && i!=0) {
            X = space;
            Y = Y + height+5;
        }
        else{
            X = X + (space+width);
        }
    }
    
    return page;
}

- (NSInteger)numberOfPagesInPageView:(KKPageScrollView*)pageView{
    NSDictionary *groupInfo = [[KKEmoticonView emotionPlistArray] objectAtIndex:self.currentGroupIndex];
    NSArray *items = [groupInfo objectForKey:@"data"];
    
    //表情之间间隙10
    CGFloat space = 10;
    //每一行的表情个数
    NSInteger countPerRow = (NSInteger)((self.frame.size.width-space)/(35+space));
    NSInteger countPerPage = countPerRow*4-1;
    
    if ([items count]%countPerPage==0) {
        NSInteger totalPage = [items count]/countPerPage;
        self.pageControl.numberOfPages = totalPage;
        return totalPage;
    }
    else{
        NSInteger totalPage = [items count]/countPerPage + 1;
        self.pageControl.numberOfPages = totalPage;
        return totalPage;
    }
}

- (BOOL)pageViewCanRepeat:(KKPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KKPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    self.pageControl.currentPage = pageIndex;
}

#pragma mark==================================================
#pragma mark== 手势操作
#pragma mark==================================================
- (void)singleTap:(UITapGestureRecognizer*)tapGestureRecognizer{
    //处理单击操作
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonView:didSelectedItem:)]) {
        NSDictionary *groupInfo = [[KKEmoticonView emotionPlistArray] objectAtIndex:self.currentGroupIndex];
        NSArray *items = [groupInfo objectForKey:@"data"];
        NSDictionary *item = [items objectAtIndex:[tapGestureRecognizer view].tag];
        [myDelegate emoticonView:self didSelectedItem:item];
        
        [self.selectedItems addObject:item];
    }
}

- (void)longPressMessage:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [recognizer locationInView:self.myPageView];
        if (!CGRectContainsPoint(self.frame, point)) {
            //处理单击操作
            Class currentClass = object_getClass(myDelegate);
            if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonView:didSelectedItem:forSend:)]) {
                NSDictionary *groupInfo = [[KKEmoticonView emotionPlistArray] objectAtIndex:self.currentGroupIndex];
                NSArray *items = [groupInfo objectForKey:@"data"];
                NSDictionary *item = [items objectAtIndex:[recognizer view].tag];
                [myDelegate emoticonView:self didSelectedItem:item forSend:YES];
            }
        }
        
        UIImageView *showView = (UIImageView*)[self.myPageView viewWithTag:KKEmoticonView_ShowingView_Tag];
        [showView removeFromSuperview];
    }
    else if(recognizer.state == UIGestureRecognizerStateCancelled){
        CGPoint point = [recognizer locationInView:self.myPageView];
        if (!CGRectContainsPoint(self.frame, point)) {
            //处理单击操作
            Class currentClass = object_getClass(myDelegate);
            if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(emoticonView:didSelectedItem:forSend:)]) {
                NSDictionary *groupInfo = [[KKEmoticonView emotionPlistArray] objectAtIndex:self.currentGroupIndex];
                NSArray *items = [groupInfo objectForKey:@"data"];
                NSDictionary *item = [items objectAtIndex:[recognizer view].tag];
                [myDelegate emoticonView:self didSelectedItem:item forSend:YES];
            }
        }

        UIImageView *showView = (UIImageView*)[self.myPageView viewWithTag:KKEmoticonView_ShowingView_Tag];
        [showView removeFromSuperview];
    }
    else if(recognizer.state == UIGestureRecognizerStateBegan){
        CGPoint point = [recognizer locationInView:self.myPageView];
        UIImageView *showView = [[UIImageView alloc]initWithFrame:CGRectMake(point.x-80, point.y-140, 120, 120)];
        
        NSString *filepath = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/QQ_Sentface_Back.png", [[NSBundle mainBundle] bundlePath]];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        showView.image = image;
        
        showView.tag = KKEmoticonView_ShowingView_Tag;
        UIImageView *imageView = [[UIImageView alloc]init];
        CGRect frame = CGRectMake(33, 27, 60, 60);
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [imageView showImageData:[KKEmoticonView emotionData_OfGroupIndex:self.currentGroupIndex subIndex:recognizer.view.tag] inFrame:frame];
        [showView addSubview:imageView];
        [self.myPageView addSubview:showView];
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint point = [recognizer locationInView:self.myPageView];
        UIImageView *showView = (UIImageView*)[self.myPageView viewWithTag:KKEmoticonView_ShowingView_Tag];
        showView.frame = CGRectMake(point.x-80, point.y-140, 120, 120);
    }
}


#pragma mark==================================================
#pragma mark== 表情
#pragma mark==================================================
+ (NSArray*)emotionPlistArray{
    return [[KKEmoticonViewCacheManager defaultManager] emotionsAll];
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *emotionPlistPath = [NSString stringWithFormat:@"%@/KKEmoticons.bundle/KKEmoticons.plist", bundlePath];
//    NSArray *emotionsAll = [NSArray arrayWithContentsOfFile:emotionPlistPath];
//    return emotionsAll;
}

+ (NSData*)emotionData_OfGroupIndex:(NSInteger)index subIndex:(NSInteger)subIndex{
    NSDictionary *groupInfo = [[KKEmoticonView emotionPlistArray] objectAtIndex:index];
//    NSArray *groupName = [groupInfo objectForKey:kEmoticonGroupTitle];
    NSArray *items = [groupInfo objectForKey:@"data"];
    NSString *imageName = [[items objectAtIndex:subIndex] objectForKey:kEmoticonImageName];
    NSString *filepath = [NSString stringWithFormat:@"%@/NIMKitEmoticon.bundle/Emoji/%@", [[NSBundle mainBundle] bundlePath],imageName];
    
    if ([[[KKEmoticonViewCacheManager defaultManager] emotionDataCache] objectForKey:filepath]) {
        return [[[KKEmoticonViewCacheManager defaultManager] emotionDataCache] objectForKey:filepath];
    }

    UIImage *image = [UIImage imageWithContentsOfFile:filepath];
    NSData *returnData = UIImagePNGRepresentation(image);
    [[KKEmoticonViewCacheManager defaultManager] saveData:returnData forKey:filepath];
    return returnData;
}

+ (NSData*)emotionData_OfTitle:(NSString*)aTitle{
    NSArray *array = [KKEmoticonView emotionPlistArray];
    NSInteger groupIndex = NSNotFound;
    NSInteger subIndex = NSNotFound;
    
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *groupInfo = [array objectAtIndex:i];
        NSArray *items = [groupInfo objectForKey:@"data"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag == %@",aTitle];
        NSArray *filteredArray = [items filteredArrayUsingPredicate:predicate];
        if (filteredArray && [filteredArray count]>0) {
            NSDictionary *findObject = [filteredArray objectAtIndex:0];
            groupIndex = i;
            subIndex = [items indexOfObject:findObject];
        }
        for (NSInteger j=0; j<[items count]; j++) {
            NSString *imageName = [[items objectAtIndex:j] objectForKey:kEmoticonImageName];
            if ([imageName isEqualToString:aTitle]) {
                groupIndex = i;
                subIndex = j;
                break;
            }
        }
        if (groupIndex!=NSNotFound && subIndex!=NSNotFound) {
            break;
        }
    }
    
    if (groupIndex!=NSNotFound && subIndex!=NSNotFound) {
        return [KKEmoticonView emotionData_OfGroupIndex:groupIndex subIndex:subIndex];
    }
    else{
        return nil;
    }
}

+ (BOOL)isExistEmotionData_OfTitle:(NSString*)aTitle{
    NSArray *array = [KKEmoticonView emotionPlistArray];
    NSInteger groupIndex = NSNotFound;
    NSInteger subIndex = NSNotFound;
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *groupInfo = [array objectAtIndex:i];
        NSArray *items = [groupInfo objectForKey:@"data"];
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tag == %@ ",aTitle];
        NSArray *filteredArray = [items filteredArrayUsingPredicate:predicate];
        if (filteredArray && [filteredArray count]>0) {
            NSDictionary *findObject = [filteredArray objectAtIndex:0];
            groupIndex = i;
            subIndex = [items indexOfObject:findObject];
        }

        for (NSInteger j=0; j<[items count]; j++) {
            NSString *imageName = [[items objectAtIndex:j] objectForKey:kEmoticonImageName];
            if ([imageName isEqualToString:aTitle]) {
                groupIndex = i;
                subIndex = j;
                break;
            }
        }
        
        if (groupIndex!=NSNotFound && subIndex!=NSNotFound) {
            break;
        }
    }
    
    if (groupIndex!=NSNotFound && subIndex!=NSNotFound) {
        return YES;
    }
    else{
        return NO;
    }
}

@end

