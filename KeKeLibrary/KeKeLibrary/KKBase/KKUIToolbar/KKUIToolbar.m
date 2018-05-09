//
//  KKUIToolbar.m
//  KKLibray
//
//  Created by liubo on 2018/4/19.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKUIToolbar.h"
#import "KKCategory.h"

@implementation KKUIToolbar

+ (KKUIToolbar*)toolBarForStyle:(KKUIToolbarStyle)aStyle
                       delegate:(id<KKUIToolbarDelegate>)aDelegate
                     targetView:(id)aTargetView{
    
    KKUIToolbar * topView = [[KKUIToolbar alloc]initWithFrame:CGRectMake(0, 0, KKApplicationWidth, 44)
                                                        Style:aStyle
                                                     delegate:aDelegate
                                                   targetView:aTargetView];
    return topView;
}

- (instancetype)initWithFrame:(CGRect)frame
                        Style:(KKUIToolbarStyle)aStyle
                     delegate:(id<KKUIToolbarDelegate>)aDelegate
                   targetView:(id)aTargetView{
    self = [super initWithFrame:frame];
    if (self) {
        self.targetView = aTargetView;
        self.toolBarDelegate = aDelegate;
        self.toolBarStyle = aStyle;
        
        [self setBarStyle:UIBarStyleDefault];
        
//        UIBarButtonItem * PreviousButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(previousButtonClicked)];
//
//        UIBarButtonItem * NextButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextButtonClicked)];
//
//        UIBarButtonItem * DoneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];

        NSString *string0 = nil;
        NSString *string1 = nil;
        NSString *string2 = nil;

        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [[languages objectAtIndex:0] lowercaseString];
        if ([preferredLang hasPrefix:@"zh-hans"] ||
            [preferredLang hasPrefix:@"zh-hant"] ) {
            string0 = @"上一个";
            string1 = @"下一个";
            string2 = @"完成";
        }
        else{
            string0 = @"Previous";
            string1 = @"Next";
            string2 = @"Done";
        }
        
        UIBarButtonItem * PreviousButton = [[UIBarButtonItem alloc]initWithTitle:string0 style:UIBarButtonItemStyleDone target:self action:@selector(previousButtonClicked)];


        UIBarButtonItem * NextButton = [[UIBarButtonItem alloc]initWithTitle:string1 style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonClicked)];

        UIBarButtonItem * DoneButton = [[UIBarButtonItem alloc]initWithTitle:string2 style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked)];


        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        if (self.toolBarStyle==KKUIToolbarStyle_None) {
            NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,DoneButton,nil];
            [self setItems:buttonsArray];
        }
        else if (self.toolBarStyle==KKUIToolbarStyle_PreviousYES_NextNO){
            [NextButton setTintColor:[UIColor lightGrayColor]];
            NextButton.enabled = NO;
            
            NSArray * buttonsArray = [NSArray arrayWithObjects:PreviousButton,NextButton,btnSpace,DoneButton,nil];
            [self setItems:buttonsArray];
        }
        else if (self.toolBarStyle==KKUIToolbarStyle_PreviousYES_NextYES){
            NSArray * buttonsArray = [NSArray arrayWithObjects:PreviousButton,NextButton,btnSpace,DoneButton,nil];
            [self setItems:buttonsArray];
        }
        else if (self.toolBarStyle==KKUIToolbarStyle_PreviousNO_NextYES){
            [PreviousButton setTintColor:[UIColor lightGrayColor]];
            PreviousButton.enabled = NO;
            NSArray * buttonsArray = [NSArray arrayWithObjects:PreviousButton,NextButton,btnSpace,DoneButton,nil];
            [self setItems:buttonsArray];
        }
        else{
            
        }
        
        if ([self.targetView isKindOfClass:[UITextView class]]) {
            ((UITextView*)self.targetView).inputAccessoryView = self;
            [self.targetView reloadInputViews];
        }
        else if ([self.targetView isKindOfClass:[UITextField class]]){
            ((UITextField*)self.targetView).inputAccessoryView = self;
            [self.targetView reloadInputViews];
        }
        else{
            
        }
        
    }
    return self;
}


- (void)previousButtonClicked{
    if (self.toolBarDelegate && [self.toolBarDelegate respondsToSelector:@selector(KKUIToolbar_PreviousButtonClicked:)]) {
        [self.toolBarDelegate KKUIToolbar_PreviousButtonClicked:self];
    }
}

- (void)nextButtonClicked{
    if (self.toolBarDelegate && [self.toolBarDelegate respondsToSelector:@selector(KKUIToolbar_NextButtonClicked:)]) {
        [self.toolBarDelegate KKUIToolbar_NextButtonClicked:self];
    }
}

- (void)doneButtonClicked{
    if (self.toolBarDelegate && [self.toolBarDelegate respondsToSelector:@selector(KKUIToolbar_DoneButtonClicked:)]) {
        [self.toolBarDelegate KKUIToolbar_DoneButtonClicked:self];
    }
}

@end
