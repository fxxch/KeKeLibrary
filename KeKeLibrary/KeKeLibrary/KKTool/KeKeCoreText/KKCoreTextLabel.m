//
//  KKCoreTextLabel.m
//  KKLibrary
//
//  Created by liubo on 13-5-11.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import "KKCoreTextLabel.h"
#import "UIImageView+KKWebCache.h"
#import "KKEmoticonView.h"
#import <objc/runtime.h>
#import "KKSharedInstance.h"
#import "KKCategory.h"

@interface KKCoreTextLabel ()

@property(nonatomic,copy)NSString *clearText;
@property(nonatomic,copy)NSString *touchItemKey;
@property(nonatomic,strong)NSMutableDictionary *itemsIndexDictionary;
@property(nonatomic,strong)NSMutableDictionary *itemsIndexRectDictionary;
@property(nonatomic,assign)BOOL isSelected;

@end

@implementation KKCoreTextLabel
@synthesize isSelected;
@synthesize rowSeparatorHeight;

- (void)dealloc{
    self.originText = nil;
    self.selectedBackgroundColor = nil;
    self.normalBackgroundColor = nil;
    
    self.clearText = nil;
    self.touchItemKey = nil;
    self.itemsIndexDictionary = nil;
    
    self.itemsIndexRectDictionary = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemsIndexRectDictionary = [[NSMutableDictionary alloc] init];

        self.originText = nil;
        self.selectedBackgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        self.normalBackgroundColor = [UIColor clearColor];
        self.backgroundColor = self.normalBackgroundColor;
        
        self.clearText = nil;
        self.touchItemKey = nil;
        self.itemsIndexDictionary = [[NSMutableDictionary alloc] init];
        self.textColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setDelegate:(id<KKCoreTextLabelDelegate>)delegate{
    if (_delegate) {
        return;
    }
    _delegate = delegate;
    delegateClass = object_getClass(_delegate);
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor{
    _normalBackgroundColor = nil;
    _normalBackgroundColor = normalBackgroundColor;
    self.backgroundColor = _normalBackgroundColor;
}

- (void)setCopyEnable:(BOOL)copyEnable{
    _copyEnable = copyEnable;
    if (_copyEnable) {
        // 添加长按手势
        UILongPressGestureRecognizer *longPressGesture =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMessage:)];
        [longPressGesture setDelegate:self];
        [longPressGesture setMinimumPressDuration:1.0f];
        [longPressGesture setAllowableMovement:0.0];
        [self addGestureRecognizer:longPressGesture];
    }
    else{
        for (UIGestureRecognizer *gestureRecognizer in [self gestureRecognizers]) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [self removeGestureRecognizer:gestureRecognizer];
            }
        }
    }
}


#pragma mark==================================================
#pragma mark== 手势操作
#pragma mark==================================================
- (void)longPressMessage:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    else if(recognizer.state == UIGestureRecognizerStateBegan){
        [self becomeFirstResponder] ;
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:KILocalization(@"拷贝") action:@selector(copyMessageAct:)];
        [menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem,nil]];
        [menuController setTargetRect:self.bounds inView:self];
        [menuController setMenuVisible:NO];
        [menuController setMenuVisible:YES animated:YES];
        
        isSelected = YES;
        
        self.backgroundColor = self.selectedBackgroundColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MenuDidHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action==@selector(copyMessageAct:)) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)copyMessageAct:(UIMenuItem *)menuItem{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *string = [NSString stringFromKKCoreTextString:self.originText];
    string = [string stringByReplacingOccurrencesOfString:KKCoreTextLinkText withString:@""];
    [pasteboard setString:string];
}

- (void)MenuDidHideNotification:(NSNotification*)notice{
    
    isSelected = NO;
    self.backgroundColor = self.normalBackgroundColor;
    [self setNeedsDisplay];
    [self resignFirstResponder];
}

#pragma mark==================================================
#pragma mark== 存取文字
#pragma mark==================================================
- (void)setText:(NSString *)text{
    if ([text isEqualToString:self.originText]) {
        return;
    }
    else{
        self.originText = nil;
        self.originText = text;
        
        [self.itemsIndexRectDictionary removeAllObjects];
        
        [self praserText];
        [self setNeedsDisplay];
    }
}

- (NSString *)text{
    NSString *string = [NSString stringFromKKCoreTextString:self.originText];
    string = [string stringByReplacingOccurrencesOfString:KKCoreTextLinkText withString:@""];
    return string;
}


#pragma mark==================================================
#pragma mark== 解析文字
#pragma mark==================================================
- (void)praserText{
    NSString *kkString = [NSString stringWithString:self.originText];
    
    [self.itemsIndexDictionary removeAllObjects];
    
    NSString *tempString = [NSString praseKKCortextString:kkString
                                               itemsArray:nil
                                          itemsDictionary:nil
                                     itemsIndexDictionary:self.itemsIndexDictionary
                                               forDrawing:YES];
    
    self.clearText = nil;
    self.clearText = tempString;
}


#pragma mark==================================================
#pragma mark== Touch事件
#pragma mark==================================================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isSelected) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    
    NSArray *keys = [self.itemsIndexRectDictionary allKeys];
    for (NSInteger i=0; i<[keys count]; i++) {
        NSDictionary *info = [self.itemsIndexRectDictionary objectForKey:[keys objectAtIndex:i]];
        NSString *rectString = [info validStringForKey:@"rect"];
        CGRect rect = CGRectFromString(rectString);
        if (CGRectContainsPoint(rect, point)) {
            self.touchItemKey = nil;
            self.touchItemKey = [keys objectAtIndex:i];
            break;
        }
    }
    
    if (!self.touchItemKey) {
        [super touchesBegan:touches withEvent:event];
    }
    else{
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.touchItemKey) {
        NSDictionary *info = [self.itemsIndexRectDictionary objectForKey:self.touchItemKey];
        NSDictionary *itemDic = [info objectForKey:@"information"];
        NSString *itemType = [itemDic validStringForKey:KKCoreTextItemKey_type];
        if ([itemType integerValue]==KKCoreTextItemTypeLink) {
            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(KKCoreTextLabelSelectedItem:)]) {
                KKCoreTextItem *item = [[KKCoreTextItem alloc]initWithDictionary:itemDic];
                [_delegate KKCoreTextLabelSelectedItem:item];
            }
            else{
                [super touchesEnded:touches withEvent:event];
            }
        }
        else{
            [super touchesEnded:touches withEvent:event];
        }
    }
    else{
        [super touchesEnded:touches withEvent:event];
    }
    
    //    NSLog(@"touchesEnded");
    self.touchItemKey = nil;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.touchItemKey) {
        self.touchItemKey = nil;
        //        NSLog(@"touchesCancelled");
        [self setNeedsDisplay];
    }
    else{
        [super touchesCancelled:touches withEvent:event];
    }
}


#pragma mark==================================================
#pragma mark== 描绘
#pragma mark==================================================
- (void)drawRect:(CGRect)rect{
    [self drawContent];
}

- (void)drawContent{
    
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isSelected) {
        NSArray *colorArrary = [UIColor RGBAValue:self.selectedBackgroundColor];
        //设置矩形填充颜色：
        if ([colorArrary count]>=3) {
            CGContextSetRGBFillColor(context, [[colorArrary objectAtIndex:0] floatValue], [[colorArrary objectAtIndex:1] floatValue], [[colorArrary objectAtIndex:2] floatValue], 1.0);
        }
        else{
            CGContextSetRGBFillColor(context, 0, 0, 0 , 0);
        }
        
        //填充矩形
        CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        //执行绘画
        CGContextStrokePath(context);
    }
    
    
    CGFloat upX=0;
    CGFloat upY=0;
    NSString *stringWO = @"我";
    CGSize fontSize = [stringWO sizeWithFont:self.font maxSize:CGSizeMake(300, 300)];
    
    for (int i=0; i<[self.clearText length]; ) {
        NSDictionary *pointInfo = [self.itemsIndexDictionary objectForKey:[NSString stringWithInteger:i]];

        //是节点
        if (pointInfo) {
            NSDictionary *itemInformation = [pointInfo objectForKey:@"information"];
            NSInteger itemType = [[itemInformation validStringForKey:KKCoreTextItemKey_type] integerValue];
            //表情
            if (itemType==KKCoreTextItemTypeEmotion) {
                if (self.frame.size.width - upX < fontSize.height){
                    if ([self checkLineBreakWithX:upX y:upY fontSize:fontSize isImage:YES]) {
                        break;
                    }
                    upY = upY + fontSize.height + rowSeparatorHeight;
                    upX = 0;
                }
                
                CGRect rect = CGRectMake(upX, upY, fontSize.height, fontSize.height);

                //获取图片路径
                NSString *imageTitle = [itemInformation validStringForKey:KKCoreTextItemKey_text];
                [self drawEmotionImageWithTitle:imageTitle inRect:rect];
                
                upX = upX+fontSize.height;
            }
            //图片
            else if (itemType==KKCoreTextItemTypeImage) {
                if (self.frame.size.width - upX < fontSize.height){
                    if ([self checkLineBreakWithX:upX y:upY fontSize:fontSize isImage:YES]) {
                        break;
                    }
                    upY = upY + fontSize.height + rowSeparatorHeight;
                    upX = 0;
                }
                
                CGRect rect = CGRectMake(upX, upY, fontSize.height, fontSize.height);
                
                //获取图片路径
                NSString *imageURL = [itemInformation validStringForKey:KKCoreTextItemKey_url];
                [self drawImageDataWithURL:imageURL inRect:rect];
                
                upX = upX+fontSize.height;
            }
            //超链接
            else if (itemType==KKCoreTextItemTypeLink){
                NSString *text = [self.clearText substringWithRange:NSMakeRange(i,1)];
                CGSize textSize = [text sizeWithFont:self.font maxWidth:100];
                
                if (self.frame.size.width - upX < textSize.width){
                    if ([self checkLineBreakWithX:upX y:upY fontSize:textSize isImage:NO]) {
                        break;
                    }
                    upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                    upX = 0;
                }
                
                NSString *colorString = nil;
                
                //超链接选中底色
                if (isSelected) {
                    //                        colorString = @"#FFFFFF";
                }
                else{
                    if (self.touchItemKey) {
                        NSDictionary *info = [self.itemsIndexRectDictionary objectForKey:self.touchItemKey];
                        if (info) {
                            NSInteger ST = [[info validStringForKey:@"start"] integerValue];
                            NSInteger ED = [[info validStringForKey:@"end"] integerValue];
                            if (ST<=i && i<=ED) {
                                //设置矩形填充颜色：
//                                CGContextSetRGBFillColor(context, 74/255.0, 184/255.0, 243/255.0, 1.0);
                                CGContextSetRGBFillColor(context, 0.38, 0.91, 1.0, 1.0);

                                //填充矩形
                                CGContextFillRect(context, CGRectMake(upX, upY, textSize.width, MAX(fontSize.height, textSize.height)-1));
                                //执行绘画
                                CGContextStrokePath(context);
                            }
                        }
                    }
                }
                
                //文字
                colorString = [itemInformation validStringForKey:KKCoreTextItemKey_textColor];
                if ([NSString isStringEmpty:colorString]) {
                    colorString = @"#0000FF";
                }
                UIColor *color = [UIColor colorWithHexString:colorString];
                NSArray *colorArrary = [UIColor RGBAValue:color];
                if ([colorArrary count]>=3) {
                    CGContextSetRGBFillColor(context, [[colorArrary objectAtIndex:0] floatValue], [[colorArrary objectAtIndex:1] floatValue], [[colorArrary objectAtIndex:2] floatValue], 1.0);
                }
                else{
                    CGContextSetRGBFillColor(context, 1, 1, 1 , 1.0);
                }
                
                CGRect rect = CGRectMake(upX, upY,textSize.width,MAX(fontSize.height, textSize.height));
                
                [self drawText:text inRect:rect withColor:color];
                
                
                NSMutableDictionary *linkInfo = [NSMutableDictionary dictionary];
                [linkInfo setValuesForKeysWithDictionary:pointInfo];
                [linkInfo setObject:NSStringFromCGRect(rect) forKey:@"rect"];
                
                [self.itemsIndexRectDictionary setObject:linkInfo forKey:[NSString stringWithInteger:i]];
                
                upX = upX+textSize.width;
            }
            //高亮文字
            else if (itemType==KKCoreTextItemTypeHightLightColor){
                NSString *text = [self.clearText substringWithRange:NSMakeRange(i,1)];
                CGSize textSize = [text sizeWithFont:self.font maxWidth:100];
                
                if (self.frame.size.width - upX < textSize.width){
                    if ([self checkLineBreakWithX:upX y:upY fontSize:textSize isImage:NO]) {
                        break;
                    }
                    upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                    upX = 0;
                }
                
                //文字
                NSString *colorString = [itemInformation validStringForKey:KKCoreTextItemKey_textColor];
                if ([NSString isStringEmpty:colorString]) {
                    colorString = @"#0000FF";
                }
                UIColor *color = [UIColor colorWithHexString:colorString];
                NSArray *colorArrary = [UIColor RGBAValue:color];
                if ([colorArrary count]>=3) {
                    CGContextSetRGBFillColor(context, [[colorArrary objectAtIndex:0] floatValue], [[colorArrary objectAtIndex:1] floatValue], [[colorArrary objectAtIndex:2] floatValue], 1.0);
                }
                else{
                    CGContextSetRGBFillColor(context, 1, 1, 1 , 1.0);
                }
                
                [self drawText:text inRect:CGRectMake(upX, upY,textSize.width,MAX(fontSize.height, textSize.height)) withColor:color];
                
                upX = upX+textSize.width;
            }
            else{}
            
            i = i + 1;
        }
        //普通文字
        else{
            NSRange range = [self.clearText rangeOfComposedCharacterSequenceAtIndex:i];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.clearText];
            NSString *text = [[attrString attributedSubstringFromRange:range] string];
            
            if ([text isEqualToString:@""]) {
                text = [self.clearText substringWithRange:NSMakeRange(i,1)];
            }
            
            if ([text isEqualToString:@"\n"]){
                
                CGSize textSize = [UIFont sizeOfFont:self.font];
                
                if (upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight>self.frame.size.height) {
                    if ((upX+fontSize.width)<self.frame.size.width) {
                        CGRect rect = CGRectMake(upX, upY, fontSize.width, fontSize.height);
                        [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
                    }
                    else{
                        CGRect rect = CGRectMake(upX-fontSize.width, upY, fontSize.width, fontSize.height);
                        CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
                        [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
                    }
                    break;
                }
                else{
                    CGSize textSize = [UIFont sizeOfFont:self.font];
                    upY = upY + MAX(textSize.height, fontSize.height) + rowSeparatorHeight;
                    upX = 0;
                }
                
                i = i + (int)[text length];
            }
            else{
                CGSize textSize = [text sizeWithFont:self.font maxWidth:100];
                
                if (self.frame.size.width - upX < textSize.width){
                    if ([self checkLineBreakWithX:upX y:upY fontSize:textSize isImage:NO]) {
                        break;
                    }
                    upY = upY + MAX(textSize.height, fontSize.height) + rowSeparatorHeight;
                    upX = 0;
                }
                
                [self drawText:text inRect:CGRectMake(upX, upY,textSize.width,MAX(textSize.height, fontSize.height)) withColor:self.textColor];
                
                upX = upX+textSize.width;
                
                i = i + (int)[text length];
            }
            
        }
    }
}

//检查折行之后是否会超出frame
- (BOOL)checkLineBreakWithX:(CGFloat)x y:(CGFloat)y  fontSize:(CGSize)fontSize isImage:(BOOL)isImage{
    if (y + (fontSize.height + rowSeparatorHeight)*2-1>self.frame.size.height) {
        
        if (isImage) {
            if ((x+fontSize.height)<self.frame.size.width) {
                CGRect rect = CGRectMake(x, y, fontSize.height, fontSize.height);
                [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
            }
            else{
                CGRect rect = CGRectMake(x-fontSize.height, y, fontSize.height, fontSize.height);
                CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
                [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
            }
        }
        else{
            if ((x+fontSize.width)<self.frame.size.width) {
                CGRect rect = CGRectMake(x, y, fontSize.width, fontSize.height);
                [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
            }
            else{
                CGRect rect = CGRectMake(x-fontSize.width, y, fontSize.width, fontSize.height);
                CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
                [self drawText:KILocalization(@"……") inRect:rect withColor:self.textColor];
            }
        }
        
        return YES;
    }
    else{
        return NO;
    }
}

/**
 * 展示表情图片
 */
- (void)drawEmotionImageWithTitle:(NSString*)aEmotionTitle inRect:(CGRect)rect{
    
//    NSLog(@"画表情S：%@",[NSDate getStringWithFormatter:@"yyyy-MM-dd HH:mm:ss SSS"]);

    //获取图片路径
    NSData *imageData = [KKEmoticonView emotionData_OfTitle:aEmotionTitle];
    
    UIImageView *pathView =[[UIImageView alloc] initWithFrame:rect];
    pathView.contentMode = UIViewContentModeScaleAspectFill;
    pathView.clipsToBounds = YES;
    [self addSubview:pathView];
    [pathView showImageData:imageData inFrame:rect];
    
    //获取图片路径
//    NSData *imageData = [KKEmoticonView emotionData_GIF_OfTitle:aEmotionTitle];
//    UIImage *image = [UIImage imageWithData:imageData];
//    [image drawInRect:rect];
    
//    NSLog(@"画表情E：%@",[NSDate getStringWithFormatter:@"yyyy-MM-dd HH:mm:ss SSS"]);
}

/**
 * 展示图片
 */
- (void)drawImageDataWithURL:(NSString*)aURLString inRect:(CGRect)rect{
    
    //获取图片路径
    if ([aURLString isURL]) {
        UIImageView *pathView =[[UIImageView alloc] initWithFrame:rect];
        pathView.contentMode = UIViewContentModeScaleAspectFit;
        pathView.clipsToBounds = YES;
        [self addSubview:pathView];
        [pathView setImageWithURL:[NSURL URLWithString:aURLString] requestONWifi:NO placeholderImage:nil completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
            
        }];
    }
    else{
        UIImageView *pathView =[[UIImageView alloc] initWithFrame:rect];
        pathView.contentMode = UIViewContentModeScaleAspectFit;
        pathView.clipsToBounds = YES;
        [self addSubview:pathView];
        [pathView showImageData:[NSData dataWithContentsOfFile:aURLString] inFrame:rect];
    }
}

/**
 * 展示文字
 */
- (void)drawText:(NSString*)text inRect:(CGRect)rect withColor:(UIColor*)color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    [text drawInRect:rect withFont:self.font];
#else
    NSDictionary* Attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,color,NSForegroundColorAttributeName, nil];
    [text drawInRect:rect withAttributes:Attributes3];
#endif
}


@end



