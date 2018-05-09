//
//  KeKeLibraryDefine.h
//  KeKeLibrary
//
//  Created by liubo on 2018/5/9.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#ifndef KeKeLibraryDefine_h
#define KeKeLibraryDefine_h



//==================================================
// 循环引用问题
//==================================================
#define KKWeakSelf(type)    __weak   typeof(type) weak##type = type;
#define KKStrongSelf(type)  __strong typeof(type) type = weak##type;



//==================================================
// 日志打印
//==================================================
#ifdef DEBUG
#define KKLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define KKLog(format, ...)
#endif



//==================================================
// 快捷代码
//==================================================
#define Window0 ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0])


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




#endif /* KeKeLibraryDefine_h */
