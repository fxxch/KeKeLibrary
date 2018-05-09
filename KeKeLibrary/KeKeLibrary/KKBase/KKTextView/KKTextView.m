//
//  KKTextView.m
//  Demo
//
//  Created by liubo on 13-9-4.
//  Copyright (c) 2013年 liubo. All rights reserved.
//

#import "KKTextView.h"
#import "KKCategory.h"

@implementation KKTextView
@synthesize maxLength = _maxLength;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [placeHolderLabel release]; placeHolderLabel = nil;
    [placeholderColor release]; placeholderColor = nil;
    [placeholder release]; placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _maxLength = 100000;
    self.placeholder = nil;
    self.attributedPlaceholder = nil;
    self.placeholderColor = [UIColor lightGrayColor];
    self.placeHolderLabelEdgeInsets = UIEdgeInsetsMake(10, 5, 0, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)init
{
    if( (self = [super init]) )
    {
        _maxLength = 100000;
        self.placeholder = nil;
        self.attributedPlaceholder = nil;
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeHolderLabelEdgeInsets = UIEdgeInsetsMake(10, 5, 0, 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        _maxLength = 100000;
        self.placeholder = nil;
        self.attributedPlaceholder = nil;
        self.placeholderColor = [UIColor lightGrayColor];
        self.placeHolderLabelEdgeInsets = UIEdgeInsetsMake(10, 5, 0, 0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder{
    if ([placeholder isEqualToString:_placeholder]) {
        return;
    }
    else{
        _placeholder=placeholder;
        if (self.attributedPlaceholder) {
            self.placeHolderLabel.text = nil;
            self.placeHolderLabel.attributedText = _attributedPlaceholder;
        }
        else{
            self.placeHolderLabel.attributedText = nil;
            self.placeHolderLabel.text = _placeholder;
        }
    }
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder{
    if ([attributedPlaceholder isEqual:_placeholder]) {
        return;
    }
    else{
        _attributedPlaceholder = attributedPlaceholder;
        if (self.attributedPlaceholder) {
            self.placeHolderLabel.text = nil;
            self.placeHolderLabel.attributedText = _attributedPlaceholder;
        }
        else{
            self.placeHolderLabel.attributedText = nil;
            self.placeHolderLabel.text = _placeholder;
        }
    }
}

- (void)textChanged:(NSNotification *)notification{
    if(self.text.length > _maxLength){
        self.text = [self.text substringToIndex:_maxLength];
    }
//    if([NSString isStringEmpty:self.placeholder])
//    {
//        return;
//    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:20170811] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:20170811] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect{
    
    if([NSString isStringNotEmpty:self.placeholder] ||
       _attributedPlaceholder
       )
    {
        if ( self.placeHolderLabel == nil )
        {
            NSString *wo = @"我";
            
            CGSize size = [wo sizeWithFont:self.font maxSize:CGSizeMake(1000, 1000)];
            
            self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.placeHolderLabelEdgeInsets.left,self.placeHolderLabelEdgeInsets.top,self.bounds.size.width-self.placeHolderLabelEdgeInsets.top,size.height)];
            self.placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
            self.placeHolderLabel.numberOfLines = 0;
            self.placeHolderLabel.font = self.font;
            self.placeHolderLabel.backgroundColor = [UIColor clearColor];
            self.placeHolderLabel.textColor = self.placeholderColor;
            self.placeHolderLabel.alpha = 0;
            self.placeHolderLabel.tag = 20170811;
            [self addSubview:self.placeHolderLabel];
        }
        
        if (self.attributedPlaceholder) {
            self.placeHolderLabel.text = nil;
            self.placeHolderLabel.attributedText = self.attributedPlaceholder;
        }
        else{
            self.placeHolderLabel.attributedText = nil;
            self.placeHolderLabel.text = self.placeholder;
        }
        [self.placeHolderLabel sizeToFit];
        [self sendSubviewToBack:self.placeHolderLabel];
    }
    
    if( [NSString isStringEmpty:self.text] &&
       ([NSString isStringNotEmpty:self.placeholder] || self.attributedPlaceholder) )
    {
        [[self viewWithTag:20170811] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
