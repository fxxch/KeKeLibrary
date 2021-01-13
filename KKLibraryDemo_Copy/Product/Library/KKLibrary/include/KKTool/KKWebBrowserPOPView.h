//
//  KKWebBrowserPOPView.h
//  YouJia
//
//  Created by liubo on 2018/6/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKView.h"

#define KKWebPopView_ImageName @"imageName"
#define KKWebPopView_Title     @"title"

@protocol KKWebBrowserPOPViewDelegate;

@interface KKWebBrowserPOPView : KKView

@property (nonatomic,weak) id<KKWebBrowserPOPViewDelegate> delegate;

/**
 *  展示添加图层
 *
 *
 */
+ (KKWebBrowserPOPView*)showWithArray:(NSMutableArray *)aInformationArray
                             delegate:(id<KKWebBrowserPOPViewDelegate>)aDelegate;

@end


#pragma mark ==================================================
#pragma mark == KKWebBrowserPOPViewDelegate
#pragma mark ==================================================
@protocol KKWebBrowserPOPViewDelegate <NSObject>
@optional

- (void)KKWebBrowserPOPView:(KKWebBrowserPOPView*)aView didSelectIndex:(NSInteger)aIndex;


@end
