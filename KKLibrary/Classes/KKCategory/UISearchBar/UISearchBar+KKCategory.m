//
//  UISearchBar+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UISearchBar+KKCategory.h"

@implementation UISearchBar (KKCategory)

-(void)clearBackground{
    for (UIView *subView in [self subviews]) {
        for (UIView *subsubView in [subView subviews]) {
            if ([subsubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subsubView removeFromSuperview];
                break;
            }
            else{
                subsubView.backgroundColor = [UIColor clearColor];
            }
        }
        
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
            break;
        }
        else{
            subView.backgroundColor = [UIColor clearColor];
        }
    }
}

@end
