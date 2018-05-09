//
//  KKButton.m
//  GouUseCore
//
//  Created by liubo on 2017/6/14.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKButton.h"
#import "UIImageView+KKWebCache.h"
#import "KKCategory.h"
#import "KeKeLibraryDefine.h"

@implementation UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];//填充颜⾊色
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //设置绘画透明混合模式和透明度
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode == kCGBlendModeOverlay) {
        //保留透明度信息
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}
@end

@interface KKButton ()<CAAnimationDelegate>

//@property (nonatomic,assign)KKButtonType buttonType;

@property (nonatomic,strong)NSMutableDictionary *titleDictionary;
@property (nonatomic,strong)NSMutableDictionary *titleColorDictionary;
@property (nonatomic,strong)NSMutableDictionary *backgroundColorDictionary;
@property (nonatomic,strong)NSMutableDictionary *imageDictionary;

@property (nonatomic,strong)CALayer * spreadLayer;

@end

@implementation KKButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonType = KKButtonType_ImgTopTitleBottom_Center;
        self.drawnDarkerImageForHighlighted = YES;

        self.imageViewSize = CGSizeMake(44, 44);
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.spaceBetweenImgTitle = 10;
        
        self.titleDictionary = [[NSMutableDictionary alloc] init];
        self.titleColorDictionary = [[NSMutableDictionary alloc] init];
        self.backgroundColorDictionary = [[NSMutableDictionary alloc] init];
        self.imageDictionary = [[NSMutableDictionary alloc] init];
        
        NSString *keyN = [NSString stringWithInteger:UIControlStateNormal];
        NSString *keyH = [NSString stringWithInteger:UIControlStateHighlighted];
        [self.titleColorDictionary setObject:[UIColor whiteColor] forKey:keyN];
        [self.titleColorDictionary setObject:[UIColor whiteColor] forKey:keyH];
        
        [self.backgroundColorDictionary setObject:[UIColor clearColor] forKey:keyN];
        [self.backgroundColorDictionary setObject:[UIColor clearColor] forKey:keyH];

        
        [self initUI];
        
        [self reloadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(KKButtonType)aType{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonType = aType;
        self.drawnDarkerImageForHighlighted = YES;
        
        self.imageViewSize = CGSizeMake(44, 44);
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.spaceBetweenImgTitle = 10;

        self.titleDictionary = [[NSMutableDictionary alloc] init];
        self.titleColorDictionary = [[NSMutableDictionary alloc] init];
        self.backgroundColorDictionary = [[NSMutableDictionary alloc] init];
        self.imageDictionary = [[NSMutableDictionary alloc] init];

        [self initUI];
        
        [self reloadUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reloadUI];
}

- (void)setButtonType:(KKButtonType)buttonType{
    if (buttonType==_buttonType) {
        return;
    }
    else{
        _buttonType = buttonType;
        [self reloadUI];
    }
}

#pragma mark -
#pragma mark ==================================================
#pragma mark == 重写父类
#pragma mark ==================================================
- (void)setEnabled:(BOOL)enabled
{
    UIControlState priorState = self.state;
    [super setEnabled:enabled];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)setSelected:(BOOL)selected
{
    UIControlState priorState = self.state;
    [super setSelected:selected];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)setHighlighted:(BOOL)highlighted
{
    UIControlState priorState = self.state;
    [super setHighlighted:highlighted];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    UIControlState priorState = self.state;
    [super touchesBegan:touches withEvent:event];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    UIControlState priorState = self.state;
    [super touchesMoved:touches withEvent:event];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UIControlState priorState = self.state;
    [super touchesEnded:touches withEvent:event];
    [self checkStateChangedAndSendActions:priorState];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    UIControlState priorState = self.state;
    [super touchesCancelled:touches withEvent:event];
    [self checkStateChangedAndSendActions:priorState];
}

#pragma mark - Private interface implementation
- (void)checkStateChangedAndSendActions:(UIControlState)aState
{
    if(self.state != aState)
    {
        [self reloadUI];
    }
}

#pragma mark -
#pragma mark ==================================================
#pragma mark == 样式
#pragma mark ==================================================
- (void)setImageWithURL:(NSURL *)aUrl
                  title:(NSString*)aTitle
             titleColor:(UIColor*)aTitleColor
        backgroundColor:(UIColor*)aBackgroundColor
               forState:(UIControlState)state{
    
    __block NSString *key = [NSString stringWithInteger:state];
    if ([NSString isStringNotEmpty:aTitle]) {
        [self.titleDictionary setObject:aTitle forKey:key];
    }
    else{
        [self.titleDictionary removeObjectForKey:key];
    }
    
    if (aTitleColor) {
        [self.titleColorDictionary setObject:aTitleColor forKey:key];
    }
    else{
        [self.titleColorDictionary removeObjectForKey:key];
    }
    
    if (aBackgroundColor) {
        [self.backgroundColorDictionary setObject:aBackgroundColor forKey:key];
    }
    else{
        [self.backgroundColorDictionary removeObjectForKey:key];
    }

    UIImage *imageNormal = [self.imageDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];

    KKWeakSelf(self);
    [self.imageView setImageWithURL:aUrl requestONWifi:NO placeholderImage:imageNormal completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [weakself.imageDictionary setObject:image forKey:key];
        }
        else{
            [weakself.imageDictionary removeObjectForKey:key];
        }
        
        [weakself reloadUI];
    }];
    
    [self reloadUI];
}

- (void)setImage:(UIImage *)aImage
           title:(NSString*)aTitle
      titleColor:(UIColor*)aTitleColor
 backgroundColor:(UIColor*)aBackgroundColor
        forState:(UIControlState)state{
    
    NSString *key = [NSString stringWithInteger:state];
    if ([NSString isStringNotEmpty:aTitle]) {
        [self.titleDictionary setObject:aTitle forKey:key];
    }
    else{
        [self.titleDictionary removeObjectForKey:key];
    }
    
    if (aTitleColor) {
        [self.titleColorDictionary setObject:aTitleColor forKey:key];
    }
    else{
        [self.titleColorDictionary removeObjectForKey:key];
    }
    
    if (aBackgroundColor) {
        [self.backgroundColorDictionary setObject:aBackgroundColor forKey:key];
    }
    else{
        [self.backgroundColorDictionary removeObjectForKey:key];
    }

    if (aImage) {
        [self.imageDictionary setObject:aImage forKey:key];
    }
    else{
        [self.imageDictionary removeObjectForKey:key];
    }
    
    [self reloadUI];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    NSString *key = [NSString stringWithInteger:state];
    if ([NSString isStringNotEmpty:title]) {
        [self.titleDictionary setObject:title forKey:key];
    }
    else{
        [self.titleDictionary removeObjectForKey:key];
    }
    [self reloadUI];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    NSString *key = [NSString stringWithInteger:state];
    if (color) {
        [self.titleColorDictionary setObject:color forKey:key];
    }
    else{
        [self.titleColorDictionary removeObjectForKey:key];
    }
    [self reloadUI];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    NSString *key = [NSString stringWithInteger:state];
    if (image) {
        [self.imageDictionary setObject:image forKey:key];
    }
    else{
        [self.imageDictionary removeObjectForKey:key];
    }
    
    [self reloadUI];
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    NSString *key = [NSString stringWithInteger:state];
    if (color) {
        [self.backgroundColorDictionary setObject:color forKey:key];
    }
    else{
        [self.backgroundColorDictionary removeObjectForKey:key];
    }
    
    [self reloadUI];
}

- (void)setImageWithURL:(NSURL *)url
               forState:(KKControlState)state
              completed:(KKImageLoadCompletedBlock)completedBlock{
    __block NSString *key = [NSString stringWithInteger:state];
    
    UIImage *imageNormal = [self.imageDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];

    KKWeakSelf(self);
    [self.imageView setImageWithURL:url requestONWifi:NO placeholderImage:imageNormal completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [weakself.imageDictionary setObject:image forKey:key];
        }
        else{
            [weakself.imageDictionary removeObjectForKey:key];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself reloadUI];

            if (completedBlock) {
                completedBlock(imageData,error,isFromRequest);
            }
        });
    }];
}

- (UIImage*)imageForState:(UIControlState)state{
    NSString *key = [NSString stringWithInteger:state];
    return [self.imageDictionary objectForKey:key];
}


#pragma mark -
#pragma mark ==================================================
#pragma mark == 界面
#pragma mark ==================================================

- (void)initUI{
    self.imageView = [[UIImageView alloc] init];
    [self.imageView clearBackgroundColor];
    [self addSubview:self.imageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor darkTextColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textLabel];
    
    self.topLineView = [[UIImageView alloc] init];
    self.topLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topLineView];
    
    self.leftLineView = [[UIImageView alloc] init];
    self.leftLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.leftLineView];

    self.bottomLineView = [[UIImageView alloc] init];
    self.bottomLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomLineView];

    self.rightLineView = [[UIImageView alloc] init];
    self.rightLineView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.rightLineView];
    
    self.topLineView.frame = CGRectMake(0, 0, self.frame.size.width, 2.0);
    self.leftLineView.frame = CGRectMake(0, 0, 2.0, self.frame.size.height);
    self.bottomLineView.frame = CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2.0);
    self.rightLineView.frame = CGRectMake(self.frame.size.width-2, 0, 2.0, self.frame.size.height);
}

- (void)reloadUI{
    
    CGSize imageSize = self.imageViewSize;
    NSString *key = [NSString stringWithInteger:self.state];
    UIImage *image = [self.imageDictionary objectForKey:key];
    if (!image) {
        image = [self.imageDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];
    }
    if (!image) {
        imageSize = CGSizeZero;
    }
    NSString *title = [self.titleDictionary objectForKey:key];
    if ([NSString isStringEmpty:title]) {
        title = [self.titleDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];
    }
    CGFloat spaceBetween = self.spaceBetweenImgTitle;
    if (CGSizeEqualToSize(imageSize, CGSizeZero) ||
        [NSString isStringEmpty:title]) {
        spaceBetween = 0;
    }

    CGFloat left = (self.edgeInsets.left<0)?0:self.edgeInsets.left;
    CGFloat right = (self.edgeInsets.right<0)?0:self.edgeInsets.right;
    CGFloat top = (self.edgeInsets.top<0)?0:self.edgeInsets.top;
    CGFloat bottom = (self.edgeInsets.bottom<0)?0:self.edgeInsets.bottom;

    /* 图片在上，文字在下，整体居左 */
    if (self.buttonType==KKButtonType_ImgTopTitleBottom_Left) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [self.textLabel.text sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000)];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;

        CGFloat img_x = left;
        CGFloat img_y = y;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat txt_x = left;
        CGFloat txt_y = CGRectGetMaxY(self.imageView.frame)+spaceBetween;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片在上，文字在下，整体居中 */
    else if (self.buttonType==KKButtonType_ImgTopTitleBottom_Center) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;
        
        CGFloat img_x = (self.frame.size.width-self.imageViewSize.width)/2.0;
        CGFloat img_y = y;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);

        CGFloat txt_x = (self.frame.size.width-titleSize.width)/2.0;
        CGFloat txt_y = CGRectGetMaxY(self.imageView.frame)+spaceBetween;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    /* 图片在上，文字在下，整体居右 */
    else if (self.buttonType==KKButtonType_ImgTopTitleBottom_Right) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;
        
        CGFloat img_x = self.frame.size.width-right-imageSize.width;
        CGFloat img_y = y;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat txt_x = left;
        CGFloat txt_y = CGRectGetMaxY(self.imageView.frame)+spaceBetween;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    /* 图片在下，文字在上，整体居左 */
    else if (self.buttonType==KKButtonType_ImgBottomTitleTop_Left) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;
        
        CGFloat txt_x = left;
        CGFloat txt_y = y;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;

        CGFloat img_x = left;
        CGFloat img_y = CGRectGetMaxY(self.textLabel.frame)+spaceBetween;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    /* 图片在下，文字在上，整体居中 */
    else if (self.buttonType==KKButtonType_ImgBottomTitleTop_Center) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }


        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;
        
        CGFloat txt_x = (self.frame.size.width-titleSize.width)/2.0;
        CGFloat txt_y = y;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = CGRectGetMaxY(self.textLabel.frame)+spaceBetween;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    /* 图片在下，文字在上，整体居右 */
    else if (self.buttonType==KKButtonType_ImgBottomTitleTop_Right) {
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        CGFloat y = (self.frame.size.height-(imageSize.height+spaceBetween+titleSize.height))/2.0;
        
        CGFloat txt_x = self.frame.size.width-titleSize.width-right;
        CGFloat txt_y = y;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
        
        CGFloat img_x = self.frame.size.width-imageSize.width-right;
        CGFloat img_y = CGRectGetMaxY(self.textLabel.frame)+spaceBetween;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    
    /* 图片在左，文字在右，整体居左 */
    else if (self.buttonType==KKButtonType_ImgLeftTitleRight_Left) {
        
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat img_x = left;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);

        CGFloat txt_x = CGRectGetMaxX(self.imageView.frame)+spaceBetween;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片在左，文字在右，整体居中 */
    else if (self.buttonType==KKButtonType_ImgLeftTitleRight_Center) {
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat img_x = (self.frame.size.width-imageSize.width-spaceBetween-titleSize.width-left-right)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat txt_x = CGRectGetMaxX(self.imageView.frame)+spaceBetween;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片在左，文字在右，整体居右 */
    else if (self.buttonType==KKButtonType_ImgLeftTitleRight_Right) {
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat img_x = self.frame.size.width-right-imageSize.width-spaceBetween-titleSize.width;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat txt_x = CGRectGetMaxX(self.imageView.frame)+spaceBetween;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
    /* 图片在右，文字在左，整体居左 */
    else if (self.buttonType==KKButtonType_ImgRightTitleLeft_Left) {
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;

        CGFloat img_x = CGRectGetMaxX(self.textLabel.frame)+spaceBetween;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    /* 图片在右，文字在左，整体居中 */
    else if (self.buttonType==KKButtonType_ImgRightTitleLeft_Center) {
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = (self.frame.size.width-imageSize.width-spaceBetween-titleSize.width-left-right)/2.0;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;

        CGFloat img_x = CGRectGetMaxX(self.textLabel.frame)+spaceBetween;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    /* 图片在右，文字在左，整体居右 */
    else if (self.buttonType==KKButtonType_ImgRightTitleLeft_Right) {
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = self.frame.size.width-right-titleSize.width-imageSize.width-spaceBetween;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat img_x = CGRectGetMaxX(self.textLabel.frame)+spaceBetween;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
    }
    
    /* 图片在左，文字在右，左右分散对齐 */
    else if (self.buttonType==KKButtonType_ImgLeftTitleRight_Edge) {
        
        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        
        CGFloat img_x = left;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);

        CGFloat txt_x = self.frame.size.width-right-titleSize.width;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    /* 图片在右，文字在左，左右分散对齐 */
    else if (self.buttonType==KKButtonType_ImgRightTitleLeft_Edge) {

        CGFloat textWidth = self.frame.size.width-left-right-imageSize.width-spaceBetween;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        
        CGFloat img_x = self.frame.size.width-right-imageSize.width;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat txt_x = left;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
    /* 图片作为Button背景，文字在左上角 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleLeftTop) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);

        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        
        CGFloat txt_x = left;
        CGFloat txt_y = top;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片作为Button背景，文字在左中 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleLeftCenter) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        
        CGFloat txt_x = left;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片作为Button背景，文字在左下 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleLeftBottom) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }

        
        CGFloat txt_x = left;
        CGFloat txt_y = self.frame.size.height-bottom-titleSize.height;
        CGFloat txt_w = titleSize.width;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    /* 图片作为Button背景，文字在中上 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleCenterTop) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = top;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    /* 图片作为Button背景，文字在中中 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleCenterCenter) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    /* 图片作为Button背景，文字在中下 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleCenterBottom) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = self.frame.size.height-bottom-titleSize.height;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    /* 图片作为Button背景，文字在右上 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleRightTop) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = top;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    /* 图片作为Button背景，文字在右中 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleRightCenter) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = (self.frame.size.height-titleSize.height)/2.0;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    /* 图片作为Button背景，文字在右下 */
    else if (self.buttonType==KKButtonType_ImgFull_TitleRightBottom) {
        CGFloat img_x = (self.frame.size.width-imageSize.width)/2.0;
        CGFloat img_y = (self.frame.size.height-imageSize.height)/2.0;
        CGFloat img_w = imageSize.width;
        CGFloat img_h = imageSize.height;
        self.imageView.frame = CGRectMake(img_x, img_y, img_w, img_h);
        
        CGFloat textWidth = self.frame.size.width-left-right;
        CGSize titleSize = [title sizeWithFont:self.textLabel.font maxSize:CGSizeMake(textWidth, 1000) lineBreakMode:self.textLabel.lineBreakMode];
        if ([NSString isStringEmpty:title]) {
            titleSize = CGSizeZero;
        }
        
        CGFloat txt_x = left;
        CGFloat txt_y = self.frame.size.height-bottom-titleSize.height;
        CGFloat txt_w = textWidth;
        CGFloat txt_h = titleSize.height;
        self.textLabel.frame = CGRectMake(txt_x, txt_y, txt_w, txt_h);
        self.textLabel.textAlignment = NSTextAlignmentRight;
    }
    else{
    
    }
    
    [self reloadUIForStateChanged];
}

- (void)reloadUIForStateChanged{
    NSString *key = [NSString stringWithInteger:self.state];
    UIImage *image = [self.imageDictionary objectForKey:key];
    UIImage *imageNormal = [self.imageDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];
    if (image) {
        
        if (self.state==UIControlStateHighlighted) {
            if (self.drawnDarkerImageForHighlighted) {
                UIImage *highlighted = [self drawnDarkerImage:image];
//            UIImage *highlighted = [image imageWithTintColor:[UIColor lightGrayColor] blendMode:kCGBlendModeColorBurn];

                self.imageView.image = highlighted;
            }
            else{
                self.imageView.image = image;
            }
            
        }
        else{
            self.imageView.image = image;
        }
    }
    else{
        if (self.state==UIControlStateHighlighted && imageNormal) {
            if (self.drawnDarkerImageForHighlighted) {
                UIImage *highlighted = [self drawnDarkerImage:imageNormal];
//            UIImage *highlighted = [imageNormal imageWithTintColor:[UIColor lightGrayColor] blendMode:kCGBlendModeColorBurn];
                self.imageView.image = highlighted;
            }
            else{
                self.imageView.image = imageNormal;
            }
        }
        else{
            self.imageView.image = imageNormal;
        }
    }
    
    NSString *title = [self.titleDictionary objectForKey:key];
    NSString *titleNormal = [self.titleDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];
    if ([NSString isStringNotEmpty:title]) {
        self.textLabel.text = title;
    }
    else{
        self.textLabel.text = titleNormal;
    }
    
    UIColor *titleColor = [self.titleColorDictionary objectForKey:key];
    UIColor *titleColorNormal = [self.titleColorDictionary objectForKey:[NSString stringWithInteger:UIControlStateNormal]];
    if (titleColor) {
        self.textLabel.textColor = titleColor;
    }
    else{
        self.textLabel.textColor = titleColorNormal;
    }
    
    UIColor *backgroundColor = [self.backgroundColorDictionary objectForKey:key];
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    
//    if (self.state==UIControlStateHighlighted) {
//        [self showAnimation];
//    }
//    
}

- (void)showAnimation{
    /*--------------- 扩散动画 ---------------*/
//    CALayer * spreadLayer;
    self.spreadLayer = [CALayer layer];
    CGFloat diameter = MAX(self.frame.size.width, self.frame.size.height);  //扩散的大小
    self.spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
    self.spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
    self.spreadLayer.position = self.center;
    self.spreadLayer.backgroundColor = [[UIColor redColor] CGColor];
    [self.layer insertSublayer:self.spreadLayer below:self.imageView.layer];//把扩散层放到头像按钮下面
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5;
    animationGroup.repeatCount = 1;//重复无限次
    animationGroup.removedOnCompletion = YES;
    animationGroup.timingFunction = defaultCurve;
    animationGroup.delegate = self;
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.7;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 0.5;//动画持续时间
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 3;
    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
    opacityAnimation.removedOnCompletion = YES;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
    [self.spreadLayer addAnimation:animationGroup forKey:@"pulse"];
    /*---------------------------------------*/
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //此处执行你想要做的事情
    if (self.spreadLayer) {
        [self.spreadLayer removeFromSuperlayer];
        self.spreadLayer = nil;
    }
}

- (UIImage*) drawnDarkerImage:(UIImage *)originalImage
{
    UIImage *brighterImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:inputImage forKey:kCIInputImageKey];

    // 修改亮度   -1---1   数越大越亮
    [lighten setValue:@(-0.15) forKey:@"inputBrightness"];
    
    // 修改饱和度  0---2
//    [lighten setValue:@(1.0) forKey:@"inputSaturation"];
    
    // 修改对比度  0---4
//    [lighten setValue:@(2.0) forKey:@"inputContrast"];

    CIImage *result = [lighten valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    // 得到修改后的图片
    brighterImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return brighterImage;
}

@end
