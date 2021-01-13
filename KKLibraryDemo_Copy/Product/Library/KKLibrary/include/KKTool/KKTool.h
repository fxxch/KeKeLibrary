//
//  KKTool.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#ifndef KKTool_h
#define KKTool_h

////表情键盘 /*❤️*/
//#import "KKEmoticonView.h"
//#import "KKEmoticonViewCacheManager.h"
////版本检查 /*❤️*/
//#import "KKVersionManager.h"


#pragma mark ==================================================
#pragma mark == 其他公共组件
#pragma mark ==================================================
//按钮 /*❤️*/
#import "KKButton.h"
//授权 /*❤️*/
#import "KKAuthorizedManager.h"
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
#pragma mark == 图片全屏预览组件
#pragma mark ==================================================
#import "KKWindowImageShowViewController.h" /*❤️*/
#import "KKWindowImageShowView.h" /*❤️*/
#import "KKWindowImageShowItemView.h"
#import "KKWindowImageItem.h"

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

/* 预览系统相册的图片或者视频 */
#import "KKAlbumAssetModalPreviewController.h"/*❤️*/
#import "KKAlbumAssetModalPreviewView.h"
#import "KKAlbumAssetModalPreviewItem.h"
#import "KKAlbumAssetModalVideoPlayController.h"/*❤️*/
#import "KKAlbumAssetModalVideoPlayView.h"
#import "KKAlbumAssetModalVideoPlayBar.h"
#pragma mark ==================================================
#pragma mark == 播放/录制语音组件
#pragma mark ==================================================
//#import "KKAudioPlayer.h" /*❤️*/
//#import "KKAudioRecorder.h" /*❤️*/
//#import "KKAudioRecorderAnimationView.h" /*❤️*/
//#import "amrFileCodec.h"
//#import "dec_if.h"
//#import "if_rom.h"
//#import "interf_dec.h"
//#import "interf_enc.h"

#pragma mark ==================================================
#pragma mark == 相册选照片组件
#pragma mark ==================================================
#import "KKAlbumImagePickerController.h" /*❤️*/
#import "KKAlbumManager.h" /*❤️*/
#import "KKAlbumAssetModal.h"
#import "KKAlbumDirectoryModal.h"
#import "KKAlbumImagePickerImageViewController.h"
#import "KKAlbumImagePickerDirectoryList.h"
#import "KKAlbumImagePickerNavTitleBar.h"
#import "KKAlbumImagePickerManager.h"
#import "KKAlbumImageShowCollectionBar.h"
#import "KKAlbumImageShowCollectionBarItem.h"
#import "KKAlbumImageShowItemView.h"
#import "KKAlbumImageShowNavBar.h"
#import "KKAlbumImageShowToolBar.h"
#import "KKAlbumImageShowViewController.h"
#import "KKAlbumImageToolBar.h"
#import "AlbumImageCollectionViewCell.h"
#pragma mark ==================================================
#pragma mark == 图片裁剪
#pragma mark ==================================================
#import "KKImageCropperViewController.h" /*❤️*/
#import "KKImageCropperView.h"
#pragma mark ==================================================
#pragma mark == 可以拍照和拍视频的组件
#pragma mark ==================================================
#import "KKCameraCaptureViewController.h" /*❤️*/
#import "KKCameraCaptureShowViewController.h"
#import "KKCameraCaptureTopBar.h"
#import "XLCircleProgress.h" /*❤️*/
#import "XLCircle.h"
#pragma mark ==================================================
#pragma mark == 多张照片连拍组件
#pragma mark ==================================================
#import "KKCameraImagePickerController.h" /*❤️*/
#import "KKCameraImagePickerViewController.h"
#import "KKCameraImageShowItemView.h"
#import "KKCameraImageShowNavBar.h"
#import "KKCameraImageShowToolBar.h"
#import "KKCameraImageShowViewController.h"
#import "KKCameraImageToolBar.h"
#import "KKCameraImageTopBar.h"
#import "KKCameraWaitingView.h"
#import "KKCameraHelper.h"
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
#pragma mark == 二维码相关组件
#pragma mark ==================================================
#import "KKQRCodeManager.h"  /*❤️*/
#import "KKQRCodeScanViewController.h"  /*❤️*/
#import "KKQRCodeBackgroundAlphaView.h"
#import "KKQRCodeScanNavigarionBar.h"

#endif /* KKTool_h */
