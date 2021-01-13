//
//  KKLibraryDefine.h
//  KKLibrary
//
//  Created by liubo on 2018/5/9.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#ifndef KKLibraryDefine_h
#define KKLibraryDefine_h



//==================================================
// 循环引用问题
//==================================================
#define KKWeakSelf(type)    __weak   typeof(type) weak##type = type;
#define KKStrongSelf(type)  __strong typeof(type) type = weak##type;


#pragma mark ==================================================
#pragma mark == 默认常量值
#pragma mark ==================================================
/* 图片压缩的尺寸 */
#define CONST_CovertImageToDataSize_DefaultSize (300)
#define CONST_CovertImageToDataSize_1M (1024)
#define CONST_CovertImageToDataSize_Half1M (512)
#define CONST_CovertImageToDataSize_OriginSize (1048576) //1GB
#define CONST_CovertImageToDataSize_50K (50)

#define CONST_ListDataPerPage (15) //分页条数15条


#pragma mark ==================================================
#pragma mark == 本地化描述性文字
#pragma mark ==================================================
#import "KKLibraryLocalizationDefineKeys.h"

//==================================================
// 日志打印
//==================================================
//#ifdef DEBUG
//#define KKLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#define KKLog(format, ...)
//#endif

//==================================================
// ARC MRC
//==================================================
/*
 
 #if __has_feature(objc_arc)
 //compiling with ARC
 #else
 // compiling without ARC
 #endif
 
 */

/*
 //例子
 #if !__has_feature(objc_arc)
 #error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
 #endif
 */




#endif /* KKLibraryDefine_h */
