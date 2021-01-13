//
//  KKWindowImageItem.h
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKWindowImageItem : NSObject

@property (nonatomic , copy) NSString *_Nullable inImageURLString;/*可存值 里面没用 */
@property (nonatomic , copy) NSString *_Nullable identifier;/*可存值 里面没用 */

/* ========== 重要参数，组件会用到 ========== */
@property (nonatomic , strong) UIView *_Nullable inView; //启动的视图
@property (nonatomic , strong) UIImage *_Nullable plachHolderImage;//占位图
@property (nonatomic , copy) NSString *_Nullable originImageURLString;//原始大图的URLString

/* 慎重使用下面俩参数，容易造成内存暴增 尽量在显示单张图片的时候使用*/
@property (nonatomic , strong) UIImage *_Nullable inImage; //启动视图对应的image
@property (nonatomic , strong) NSData *_Nullable inImageData; //启动视图对应的image数据

@end
