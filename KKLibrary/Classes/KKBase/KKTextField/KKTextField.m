//
//  KKTextField.m
//  KKLibrary
//
//  Created by liubo on 13-4-27.
//
//

#import "KKTextField.h"

@implementation KKTextField
@synthesize padding = _padding;
@dynamic delegate;

// .h中警告说delegate在父类已经声明过了，子类再声明也不会重新生成新的方法了。我们就在这里使用@dynamic告诉系统delegate的setter与getter方法由用户自己实现，不由系统自动生成
#pragma mark ==================================================
#pragma mark == delegate 重设
#pragma mark ==================================================
- (void)setDelegate:(id<KKTextFieldDelegate>)delegate{
    super.delegate = delegate;
}

- (id<KKTextFieldDelegate>)delegate{
    id curDelegate = super.delegate;
    return curDelegate;
}


- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)paddingTop {
    return self.padding.top;
}

- (CGFloat)paddingBottom {
    return self.padding.bottom;
}

- (CGFloat)paddingLeft {
    return self.padding.left;
}

- (CGFloat)paddingRight {
    return self.padding.right;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect leftRect = [self leftViewRectForBounds:bounds];
    CGRect rightRect = [self rightViewRectForBounds:bounds];
    CGRect clearRect = [self clearButtonRectForBounds:bounds];
    
    CGFloat clearWidth = self.clearButtonMode==UITextFieldViewModeNever?0:CGRectGetWidth(clearRect);
    
    if (self.isFirstResponder) {
        clearWidth = self.clearButtonMode==UITextFieldViewModeUnlessEditing?0:CGRectGetWidth(clearRect);
    }
    
    return CGRectMake(self.paddingLeft+leftRect.size.width,
                      self.paddingTop,
                      bounds.size.width-self.paddingLeft-self.paddingRight-rightRect.size.width-clearWidth,
                      bounds.size.height-self.paddingTop-self.paddingBottom);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect leftRect = [self leftViewRectForBounds:bounds];
    CGRect rightRect = [self rightViewRectForBounds:bounds];
    
    return CGRectMake(self.paddingLeft+leftRect.size.width,
                      self.paddingTop,
                      bounds.size.width-self.paddingLeft-self.paddingRight-rightRect.size.width,
                      bounds.size.height-self.paddingTop-self.paddingBottom);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)deleteBackward{
    [super deleteBackward];
    
    BOOL conform = [self.delegate conformsToProtocol:@protocol(KKTextFieldDelegate)];
    BOOL canResponse = [self.delegate respondsToSelector:@selector(KKTextField_deleteBackward:)];
    if (self.delegate && conform && canResponse) {
        [self.delegate KKTextField_deleteBackward:self];
    }
}

- (void)insertText:(NSString *)text{
    [super insertText:text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKTextField:insertText:)]) {
        [self.delegate KKTextField:self insertText:text];
    }
}

@end
