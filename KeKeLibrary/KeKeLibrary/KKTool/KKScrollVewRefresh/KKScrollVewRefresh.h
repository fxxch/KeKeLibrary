//
//  KKScrollVewRefresh.h
//  Demo
//
//  Created by liubo on 14-9-17.
//  Copyright (c) 2014年 liubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKRefreshHeaderView.h"
#import "KKRefreshFooterDraggingView.h"
#import "KKRefreshFooterAutoView.h"

@interface KKScrollVewRefresh : NSObject

@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@interface UIScrollView (KKScrollVewRefreshExtension)

/*必须实现以下方法 见附件一*/
- (void)scrollViewDidScroll;

- (void)scrollViewDidEndDragging;

@end

/**附件一
 【delegate必须实现以下方法】

 #pragma mark ==================================================
 #pragma mark ==UIScrollViewDelegate
 #pragma mark ==================================================
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [scrollView scrollViewDidScroll];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [scrollView scrollViewDidEndDragging];
 }
 */


/**附件二
 【以下方法可供使用】KKRefreshHeaderView、KKRefreshFooterDraggingView、KKRefreshFooterAutoView 类似

 //开启 刷新数据
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

//关闭 刷新数据
- (void)hideRefreshHeader;

//开始 刷新数据
- (void)startRefreshHeader;

//停止 刷新数据
- (void)stopRefreshHeader:(NSString*)aText;
- (void)stopRefreshHeader;
*/





