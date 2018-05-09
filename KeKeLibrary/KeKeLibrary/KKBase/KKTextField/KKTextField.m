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

@end
