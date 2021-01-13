//
//  KKCameraImagePickerViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/11.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKViewController.h"


@protocol KKCameraImagePickerDelegate;

@interface KKCameraImagePickerViewController : KKViewController

/* 拍摄的照片最大数量 */
@property (nonatomic,assign)NSInteger numberOfPhotosNeedSelected;

/* 是否需要编辑，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)BOOL editEnable;

/* 图片的裁剪大小，仅在拍摄数量为1的时候有效（即numberOfPhotosNeedSelected为1的时候有效） */
@property (nonatomic,assign)CGSize cropSize;

/* 拍摄的图片的大小（KB），如果过大会自动压缩 */
@property (nonatomic,assign)NSInteger imageFileMaxSize;

/* KKCameraImagePickerDelegate */
@property(nonatomic,weak)id<KKCameraImagePickerDelegate> delegate;

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      editEnable:(BOOL)aEditEnable
                        cropSize:(CGSize)aCropSize
                imageFileMaxSize:(NSInteger)aImageFileMaxSize;

@end
