//
//  KKLibraryLocalizationDefineKeys.h
//  BM
//
//  Created by liubo on 2020/1/2.
//  Copyright © 2020 bm. All rights reserved.
//

#ifndef KKLibraryLocalizationDefineKeys_h
#define KKLibraryLocalizationDefineKeys_h

#import "KKLibraryLocalization.h"

#pragma mark ==================================================
#pragma mark == 通用
#pragma mark ==================================================
//@"确定"
#define KKLibLocalizable_Common_OK                 KKLibLocalForKey(@"KKLibLocalizable.Common.OK")
//@"温馨提示"
#define KKLibLocalizable_Common_Notice             KKLibLocalForKey(@"KKLibLocalizable.Common.Notice")
//@"上一个"
#define KKLibLocalizable_Common_Previous           KKLibLocalForKey(@"KKLibLocalizable.Common.Previous")
//@"下一个"
#define KKLibLocalizable_Common_Next               KKLibLocalForKey(@"KKLibLocalizable.Common.Next")
//@"完成"
#define KKLibLocalizable_Common_Done               KKLibLocalForKey(@"KKLibLocalizable.Common.Done")
//@"取消"
#define KKLibLocalizable_Common_Cancel             KKLibLocalForKey(@"KKLibLocalizable.Common.Cancel")
//@"返回"
#define KKLibLocalizable_Common_Back               KKLibLocalForKey(@"KKLibLocalizable.Common.Back")
//@"关闭"
#define KKLibLocalizable_Common_Close              KKLibLocalForKey(@"KKLibLocalizable.Common.Close")
//@"拷贝"
#define KKLibLocalizable_Common_Copy               KKLibLocalForKey(@"KKLibLocalizable.Common.Copy")
//@"保存"
#define KKLibLocalizable_Common_Save               KKLibLocalForKey(@"KKLibLocalizable.Common.Save")
//@"保存到手机相册"
#define KKLibLocalizable_Common_SaveToAlbum        KKLibLocalForKey(@"KKLibLocalizable.Common.SaveToAlbum")
//@"成功"
#define KKLibLocalizable_Common_Success            KKLibLocalForKey(@"KKLibLocalizable.Common.Success")
//@"失败"
#define KKLibLocalizable_Common_Failed             KKLibLocalForKey(@"KKLibLocalizable.Common.Failed")
//@"复制链接"
#define KKLibLocalizable_Common_CopyLink           KKLibLocalForKey(@"KKLibLocalizable.Common.CopyLink")
//@"在浏览器中打开"
#define KKLibLocalizable_Common_OpenInSafari       KKLibLocalForKey(@"KKLibLocalizable.Common.OpenInSafari")
//@"在其他应用中打开"
#define KKLibLocalizable_Common_OpenInOtherApp     KKLibLocalForKey(@"KKLibLocalizable.Common.OpenInOtherApp")
//@"刷新"
#define KKLibLocalizable_Common_Refresh            KKLibLocalForKey(@"KKLibLocalizable.Common.Refresh")
//@"文件错误"
#define KKLibLocalizable_Common_FileError          KKLibLocalForKey(@"KKLibLocalizable.Common.FileError")
//@"无法打开网页"
#define KKLibLocalizable_Common_CannotOpenURL      KKLibLocalForKey(@"KKLibLocalizable.Common.CannotOpenURL")

#pragma mark ==================================================
#pragma mark == 相册文件夹类型名字
#pragma mark ==================================================
//@"我的照片流"
#define KKLibLocalizable_Album_ImageStream         KKLibLocalForKey(@"KKLibLocalizable.Album.ImageStream")
//@"相机胶卷"
#define KKLibLocalizable_Album_UserLibrary         KKLibLocalForKey(@"KKLibLocalizable.Album.UserLibrary")
//@"全景照片"
#define KKLibLocalizable_Album_Panoramas           KKLibLocalForKey(@"KKLibLocalizable.Album.Panoramas")
//@"视频"
#define KKLibLocalizable_Album_Videos              KKLibLocalForKey(@"KKLibLocalizable.Album.Videos")
//@"个人收藏"
#define KKLibLocalizable_Album_Favorites           KKLibLocalForKey(@"KKLibLocalizable.Album.Favorites")
//@"延时摄影"
#define KKLibLocalizable_Album_Timelapses          KKLibLocalForKey(@"KKLibLocalizable.Album.Timelapses")
//@"最近添加"
#define KKLibLocalizable_Album_RecentlyAdded       KKLibLocalForKey(@"KKLibLocalizable.Album.RecentlyAdded")
//@"连拍快照"
#define KKLibLocalizable_Album_Bursts              KKLibLocalForKey(@"KKLibLocalizable.Album.Bursts")
//@"慢动作"
#define KKLibLocalizable_Album_SlomoVideos         KKLibLocalForKey(@"KKLibLocalizable.Album.SlomoVideos")
//@"自拍"
#define KKLibLocalizable_Album_SelfPortraits       KKLibLocalForKey(@"KKLibLocalizable.Album.SelfPortraits")
//@"屏幕快照"
#define KKLibLocalizable_Album_Screenshots         KKLibLocalForKey(@"KKLibLocalizable.Album.Screenshots")
//@"人像"
#define KKLibLocalizable_Album_DepthEffect         KKLibLocalForKey(@"KKLibLocalizable.Album.DepthEffect")
//@"实况照片"
#define KKLibLocalizable_Album_LivePhotos          KKLibLocalForKey(@"KKLibLocalizable.Album.LivePhotos")
//@"动图"
#define KKLibLocalizable_Album_Animated            KKLibLocalForKey(@"KKLibLocalizable.Album.Animated")
//@"最近删除"
#define KKLibLocalizable_Album_RecentlyDeleted     KKLibLocalForKey(@"KKLibLocalizable.Album.RecentlyDeleted")
//@"所有照片"
#define KKLibLocalizable_Album_AllPhotos           KKLibLocalForKey(@"KKLibLocalizable.Album.AllPhotos")
//@"图库"
#define KKLibLocalizable_Album_DefaultName         KKLibLocalForKey(@"KKLibLocalizable.Album.DefaultName")
//@"图片裁切"
#define KKLibLocalizable_Album_ImageCut            KKLibLocalForKey(@"KKLibLocalizable.Album.ImageCut")
//@"照片"
#define KKLibLocalizable_Album_Photo               KKLibLocalForKey(@"KKLibLocalizable.Album.Photo")
//@"预览"
#define KKLibLocalizable_Album_Preview             KKLibLocalForKey(@"KKLibLocalizable.Album.Preview")
//@"原图"
#define KKLibLocalizable_Album_Origin             KKLibLocalForKey(@"KKLibLocalizable.Album.Origin")
//@"编辑"
#define KKLibLocalizable_Album_Edit                KKLibLocalForKey(@"KKLibLocalizable.Album.Edit")
//@"已达到最大数量限制"
#define KKLibLocalizable_Album_MaxLimited          KKLibLocalForKey(@"KKLibLocalizable.Album.MaxLimited")



#pragma mark ==================================================
#pragma mark == 隐私授权
#pragma mark ==================================================
//@"没有权限访问您的通讯录"
#define KKLibLocalizable_Authorized_AddressBook  KKLibLocalForKey(@"KKLibLocalizable.Authorized.AddressBook")
//@"没有权限访问您的手机相册"
#define KKLibLocalizable_Authorized_Album        KKLibLocalForKey(@"KKLibLocalizable.Authorized.Album")
//@"没有权限访问您的手机相机"
#define KKLibLocalizable_Authorized_Camera       KKLibLocalForKey(@"KKLibLocalizable.Authorized.Camera")
//@"没有权限访问您的地理位置"
#define KKLibLocalizable_Authorized_Location     KKLibLocalForKey(@"KKLibLocalizable.Authorized.Location")
//@"没有权限访问您的麦克风"
#define KKLibLocalizable_Authorized_Microphone   KKLibLocalForKey(@"KKLibLocalizable.Authorized.Microphone")
//@"请打开通知权限以便您能及时收到新消息"
#define KKLibLocalizable_Authorized_Notification KKLibLocalForKey(@"KKLibLocalizable.Authorized.Notification")
//@"没有权限访问您的媒体库音乐"
#define KKLibLocalizable_Authorized_Music        KKLibLocalForKey(@"KKLibLocalizable.Authorized.Music")
//@"没有权限访问您的蜂窝移动网络"
#define KKLibLocalizable_Authorized_CellularData KKLibLocalForKey(@"KKLibLocalizable.Authorized.CellularData")
#define KKLibLocalizable_Authorized_OK           KKLibLocalForKey(@"KKLibLocalizable.Authorized.OK")
#define KKLibLocalizable_Authorized_Go           KKLibLocalForKey(@"KKLibLocalizable.Authorized.Go")
#define KKLibLocalizable_Authorized_Title        KKLibLocalForKey(@"KKLibLocalizable.Authorized.title")

#pragma mark ==================================================
#pragma mark == 时间格式
#pragma mark ==================================================
//@"年"
#define KKLibLocalizable_Date_Year           KKLibLocalForKey(@"KKLibLocalizable.Date.Year")
//@"月"
#define KKLibLocalizable_Date_Month          KKLibLocalForKey(@"KKLibLocalizable.Date.Month")
//@"日"
#define KKLibLocalizable_Date_Day            KKLibLocalForKey(@"KKLibLocalizable.Date.Day")
//@"时"
#define KKLibLocalizable_Date_Hour           KKLibLocalForKey(@"KKLibLocalizable.Date.Hour")
//@"分"
#define KKLibLocalizable_Date_Min            KKLibLocalForKey(@"KKLibLocalizable.Date.Min")
//@"秒"
#define KKLibLocalizable_Date_Sec            KKLibLocalForKey(@"KKLibLocalizable.Date.Sec")

#pragma mark ==================================================
#pragma mark == 刷新加载数据
#pragma mark ==================================================
//@"点击加载更多..."
#define KKLibLocalizable_refresh_LoadMoreC   KKLibLocalForKey(@"KKLibLocalizable.refresh.LoadMoreC")
//@"上拉加载更多..."
#define KKLibLocalizable_refresh_LoadMoreP   KKLibLocalForKey(@"KKLibLocalizable.refresh.LoadMoreP")
//@"加载更多..."
#define KKLibLocalizable_refresh_LoadMore    KKLibLocalForKey(@"KKLibLocalizable.refresh.LoadMore")
//@"没有更多了"
#define KKLibLocalizable_refresh_NoMore      KKLibLocalForKey(@"KKLibLocalizable.refresh.NoMore")
//@"加载中..."
#define KKLibLocalizable_refresh_Loading     KKLibLocalForKey(@"KKLibLocalizable.refresh.Loading")
//@"释放加载"
#define KKLibLocalizable_refresh_ReleaseLoad KKLibLocalForKey(@"KKLibLocalizable.refresh.ReleaseLoad")
//@"下拉刷新"
#define KKLibLocalizable_refresh_P           KKLibLocalForKey(@"KKLibLocalizable.refresh.P")
//@"释放更新"
#define KKLibLocalizable_refresh_R           KKLibLocalForKey(@"KKLibLocalizable.refresh.R")

#pragma mark ==================================================
#pragma mark == 音视频播放-查看文档
#pragma mark ==================================================
//@"音频播放"
#define KKLibLocalizable_AudioPlay                 KKLibLocalForKey(@"KKLibLocalizable.AudioPlay")
//@"查看文档"
#define KKLibLocalizable_FileShow                  KKLibLocalForKey(@"KKLibLocalizable.FileShow")
//@"用第三方应用打开"
#define KKLibLocalizable_FileShow_OpenWithOtherApp KKLibLocalForKey(@"KKLibLocalizable.FileShow.OpenWithOtherApp")
//@"暂不支持预览改格式的文件"
#define KKLibLocalizable_FileShow_NotSupportFile   KKLibLocalForKey(@"KKLibLocalizable.FileShow.NotSupportFile")

#pragma mark ==================================================
#pragma mark == 音视频录制
#pragma mark ==================================================
//@"手指松开，取消发送"
#define KKLibLocalizable_AudioKit_FingerOut    KKLibLocalForKey(@"KKLibLocalizable.AudioKit.FingerOut")
//@"手指上滑，取消发送"
#define KKLibLocalizable_AudioKit_FingerUp     KKLibLocalForKey(@"KKLibLocalizable.AudioKit.FingerUp")
//@"说话时间太短"
#define KKLibLocalizable_AudioKit_TimeTooShort KKLibLocalForKey(@"KKLibLocalizable.AudioKit.TimeTooShort")

#pragma mark ==================================================
#pragma mark == 二维码扫描
#pragma mark ==================================================
//@"扫描二维码"
#define KKLibLocalizable_QRCode_Title    KKLibLocalForKey(@"KKLibLocalizable.QRCode.Title")
//@"将二维码放入框内，即可自动扫描"
#define KKLibLocalizable_QRCode_Notice   KKLibLocalForKey(@"KKLibLocalizable.QRCode.Notice")
//@"二维码扫码失败,请重新扫描"
#define KKLibLocalizable_QRCode_Failed   KKLibLocalForKey(@"KKLibLocalizable.QRCode.Failed")


#endif /* KKLibraryLocalizationDefineKeys_h */
