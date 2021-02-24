//
//  KKTool.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#ifndef KKTool_h
#define KKTool_h

#pragma mark ==================================================
#pragma mark == 其他公共组件
#pragma mark ==================================================
//按钮 /*❤️*/
#import "KKButton.h"
//弹窗 /*❤️*/
#import "KKAlertView.h"
//空页面站位视图 /*❤️*/
#import "KKEmptyNoticeView.h"
#import "UICollectionView+KKEmptyNoticeView.h"
#import "UITableView+KKEmptyNoticeView.h"
//环形进度条 /*❤️*/
#import "KKCycleProgressView.h"
//等待转圈 /*❤️*/
#import "KKWaitingView.h"
//提示语（Tost/Tips） /*❤️*/
#import "KKToastView.h"
//横向滑动分页 /*❤️*/
#import "KKPageScrollView.h"
//PageControl /*❤️*/
#import "KKPageControl.h"
//KeyChain /*❤️*/
#import "KKKeyChainManager.h"
//打印日志 /*❤️*/
#import "KKLog.h"
//横向按钮组Segment /*❤️*/
#import "KKSegmentView.h"
//数据选择 /*❤️*/
#import "KKDataPickerView.h"
//日期选择 /*❤️*/
#import "KKDateSelectView.h"
//文字编辑 /*❤️*/
#import "KKTextEditViewController.h"
#import "KKTextEditViewStyle.h"
//长按复制、删除、编辑等选项弹窗 /*❤️*/
#import "KKWindowMenuView.h"
#import "KKWindowMenuItem.h"
//数据分组 /*❤️*/
#import "KKComparer.h"
//ActionSheet弹窗，从Window底部弹出（图片+文字 纵向的一排一个按钮） /*❤️*/
#import "KKWindowActionView.h"
#import "KKWindowActionViewItem.h"
//ActionSheet弹窗，从Window底部弹出 (图片+文字 分页的一页9个按钮)/*❤️*/
#import "WindowModalView.h"
#import "WindowModalViewItem.h"

//获取IP地址/*❤️*/
#import "KKGetIPAddress.h"
#import "KKIPAddress.h"

//AES加密/*❤️*/
#import "KKAESCrypt.h"
#import "NSData+KKCommonCryptor.h"
#import "NSData+KKBase64.h"
#import "NSString+KKBase64.h"

#import "KKActionSheet.h"
#import "KanJiSort.h"

#pragma mark ==================================================
#pragma mark == 网络监听
#pragma mark ==================================================
#import "KKNetWorkObserver.h" /*❤️*/
#import "KKReachability.h"
#pragma mark ==================================================
#pragma mark == 播放声音与振动组件
#pragma mark ==================================================
#import "KKSoundVibrateManager.h" /*❤️*/

#pragma mark ==================================================
#pragma mark == 加载数据（下拉刷新、加载更多）组件
#pragma mark ==================================================
#import "KKRefreshFooterAutoView.h" /*❤️*/
#import "KKRefreshFooterAutoStateView.h"
#import "KKRefreshFooterDraggingView.h" /*❤️*/
#import "KKRefreshFooterDraggingStateView.h"
#import "KKRefreshFooterTouchView.h" /*❤️*/
#import "KKRefreshFooterTouchStateView.h"
#import "KKRefreshHeaderView.h" /*❤️*/
#import "KKRefreshHeaderStateView.h"

#pragma mark ==================================================
#pragma mark == 网页浏览器组件
#pragma mark ==================================================
#import "KKWebBrowserViewController.h" /*❤️*/
#import "KKWebBrowserPOPView.h"
#import "KKWebBrowserPOPViewCell.h"

//#pragma mark ==================================================
//#pragma mark == 查看文档组件
//#pragma mark ==================================================
//#import "KKDocumentShowViewController.h" /*❤️*/
//#import "CanNotOpenDocumentView.h"
//#import "ShowDocumentImageView.h"
//#import "ShowDocumentOfficeView.h"
//#pragma mark ==================================================
//#pragma mark == 播放音乐视频组件
//#pragma mark ==================================================
//#import "KKAudioPlayViewController.h" /*❤️*/
//#import "KKAudioPlayViewControlBar.h"
//#import "KKAudioPlayViewTimeBar.h"
//#import "KKVideoPlayViewController.h" /*❤️*/
//#import "KKVideoPlayer.h"
//#import "KKVideoPlayerBarView.h"
//#import "KKVideoPlayerForwardView.h"
//#import "KKVideoPlayerNavigationView.h"
//#import "KKVideoPlayerVolumeView.h"
//#pragma mark ==================================================
//#pragma mark == 播放/录制语音组件
//#pragma mark ==================================================
//#import "KKAudioPlayer.h" /*❤️*/
//#import "KKAudioRecorder.h" /*❤️*/
//#import "KKAudioRecorderAnimationView.h" /*❤️*/
//#import "amrFileCodec.h"
//#import "dec_if.h"
//#import "if_rom.h"
//#import "interf_dec.h"
//#import "interf_enc.h"

//#pragma mark ==================================================
//#pragma mark == 表情键盘
//#pragma mark ==================================================
////表情键盘 /*❤️*/
//#import "KKEmoticonView.h"
//#import "KKEmoticonViewCacheManager.h"
//#pragma mark ==================================================
//#pragma mark == 版本检查
//#pragma mark ==================================================
////版本检查 /*❤️*/
//#import "KKVersionManager.h"


#endif /* KKTool_h */
