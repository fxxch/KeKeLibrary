//
//  KKTextEditViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/26.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKViewController.h"
#import "KKTextView.h"
#import "KKTextEditViewStyle.h"

@protocol KKTextEditViewControllerDelegate;


@interface KKTextEditViewController : KKViewController

@property (nonatomic,strong)KKTextView *myTextView;
@property (nonatomic,strong)UITextField *myTextField;
@property (nonatomic,strong)UILabel *maxLenthLabel;
@property (nonatomic,assign)TextEditType type;
@property (nonatomic,weak)id<KKTextEditViewControllerDelegate> delegate;

- (instancetype)initWithStyle:(KKTextEditViewStyle*)aStyle;

@end


@protocol KKTextEditViewControllerDelegate <NSObject>

- (BOOL)KKTextEditViewController:(KKTextEditViewController*)viewController
            shouldReturnWithText:(NSString*)text
                           style:(KKTextEditViewStyle*)aStyle;

@end
