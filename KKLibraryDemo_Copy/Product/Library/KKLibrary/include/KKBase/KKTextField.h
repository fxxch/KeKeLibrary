//
//  KKTextField.h
//  Kitalker
//
//  Created by liubo on 13-4-27.
//
//

#import <UIKit/UIKit.h>


@class KKTextField;

#pragma mark ==================================================
#pragma mark == KKTextFieldDelegate
#pragma mark ==================================================
@protocol KKTextFieldDelegate <NSObject,UITextFieldDelegate>
@optional

- (void)KKTextField_deleteBackward:(UITextField*)aTextField;

- (void)KKTextField:(UITextField*)aTextField insertText:(NSString *)text;

@end

@interface KKTextField : UITextField {
    UIEdgeInsets    _padding;
}

@property (nonatomic, assign) UIEdgeInsets  padding;

@property (nonatomic , weak) id<KKTextFieldDelegate> delegate;

@end


