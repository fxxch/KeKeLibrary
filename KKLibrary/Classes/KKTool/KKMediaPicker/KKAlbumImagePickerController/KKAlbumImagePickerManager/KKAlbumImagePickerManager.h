//
//  KKAlbumImagePickerManager.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKAlbumManager.h"

UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumImagePickerSelectModal;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumImagePickerUnSelectModal;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerLoadSourceFinished;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerDataSourceChanged;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumManagerIsSelectOriginChanged;
UIKIT_EXTERN NSNotificationName const NotificationName_KKAlbumAssetModalEditImageFinished;

@protocol KKAlbumImagePickerDelegate <NSObject>
@optional

//fileName: happy.jpg aExtentionName: jpg
- (NSURL*)KKAlbumImagePicker_fileURLForSave:(NSString*)fileName
                          fileExtentionName:(NSString*)aExtentionName;

//fileName: happy.jpg aExtentionName: jpg
- (NSURL*)KKAlbumImagePicker_fileURLForCompress:(NSString*)fileName
                              fileExtentionName:(NSString*)aExtentionName;

- (void)KKAlbumImagePicker_didFinishedPickImages:(NSArray<KKAlbumAssetModal*>*)aImageArray;

@end

@interface KKAlbumImagePickerManager : NSObject

/* 选取的照片最大数量 */
@property (nonatomic,assign)NSInteger numberOfPhotosNeedSelected;

/* 是否需要编辑，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)BOOL cropEnable;

/* 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)CGSize cropSize;

/* 选择的类型 */
@property (nonatomic,assign)KKAssetMediaType mediaType;

/* 是否选择原图 */
@property (nonatomic,assign)BOOL isSelectOrigin;

/* KKAlbumImagePickerDelegate */
@property(nonatomic,weak)id<KKAlbumImagePickerDelegate> delegate;

+ (KKAlbumImagePickerManager*)defaultManager;

- (void)finishedWithNavigationController:(UINavigationController*)aNavigationController;

#pragma mark ==================================================
#pragma mark == 选择
#pragma mark ==================================================
- (void)selectAssetModal:(KKAlbumAssetModal*)aModal;

- (void)deselectAssetModal:(KKAlbumAssetModal*)aModal;

- (BOOL)isSelectAssetModal:(KKAlbumAssetModal*)aModal;

- (void)clearAllObjects;

- (NSArray*)allSource;

@end
