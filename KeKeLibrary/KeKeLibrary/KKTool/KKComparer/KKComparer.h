//
//  KKComparer.h
//  KANJI
//
//  Created by liubo on 13-3-31.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KanJiSort.h"

@interface KKComparer : NSObject


//********************【数据Tableview分组】 参数说明 ********************
/*根据数组（里面每个对象都是字典）里面每个对象的key进行分组排序
    【主要用于Tableview添加索引】
    1、inputArrary 处理之前的原始数据数组
    2、key         处理之前的原始数据数组--的对象的某个被用于分组的字段
    3、outDic      处理后新的数据字典
    4、outDicKeys  SectionHeader的名字字典

 */
//******************** 应用举例 ********************
/*
    例如：
    原数组（inputArrary）：
    1.[NSDictionary dictionaryWithObjectsAndKeys:@"张三",@"trueName", nil];
    2.[NSDictionary dictionaryWithObjectsAndKeys:@"展示",@"trueName", nil];
    3.[NSDictionary dictionaryWithObjectsAndKeys:@"王五",@"trueName", nil];
    4.[NSDictionary dictionaryWithObjectsAndKeys:@"刘德华",@"trueName", nil];
    5.[NSDictionary dictionaryWithObjectsAndKeys:@"孟四",@"trueName", nil];

    关键字key：@"trueName"

    输出字典（outPutDic）：
    l{4.[NSDictionary dictionaryWithObjectsAndKeys:@"刘德华",@"trueName", nil];}

    m{5.[NSDictionary dictionaryWithObjectsAndKeys:@"孟四",@"trueName", nil];}

    w{3.[NSDictionary dictionaryWithObjectsAndKeys:@"王五",@"trueName", nil];}

    z{1.[NSDictionary dictionaryWithObjectsAndKeys:@"张三",@"trueName", nil];
      2.[NSDictionary dictionaryWithObjectsAndKeys:@"展示",@"trueName", nil];}

    输出字典的Keys(outDicKeys 排了序的):
    {l,m,w,z}
 */
+ (void)arraryGroupedByFirstCharacter:(NSArray *)inputArrary
                              withKey:(NSString*)key
                     outPutDictionary:(NSMutableDictionary*)outDic
                 outPutDictionaryKeys:(NSMutableArray*)outDicKeys;








//**********【判断字典里面的某个字段的首字母组成的字符串中 跟要比较的字符串的首字母字符串中 后者是否包含在前者之中】 **********
/*
 1、dictionary     即将比较的字典
 2、key            即将比较的字典的某个对象的key
 3、compareString  参与比较的字符串 
 */
//******************** 应用举例 ********************
/*
 例如：
 原数字典（dictionary）：
 1.[NSDictionary dictionaryWithObjectsAndKeys:@"刘德华",@"trueName", nil];
 
 2.关键字key：@"trueName"
 
 3、如果 compareString：@“德华”或者“得花” 他们生成的首字母字符串都是 @“DH”
    而原始字符串生成的首字母字符串是：@“LDH”，那么@“DH”在@“LDH”之中，那么返回YES
*/
 + (BOOL)isDictionary:(NSDictionary*)dictionary objectForKey:(NSString*)key containStringByFirstCharacterCompare:(NSString*)compareString;







//**********【判断字符串的首字母组成的字符串中 跟要比较的字符串的首字母字符串中 后者是否包含在前者之中】**********
/*
 1、oldString     即将比较的字符串
 2、compareString  参与比较的字符串
 */
//******************** 应用举例 ********************
/*
 例如：
 原数字符串（oldString）：
 1.@"刘德华";
  
 2、如果 compareString：@“德华”或者“得花” 他们生成的首字母字符串都是 @“DH”
 而原始字符串生成的首字母字符串是：@“LDH”，那么@“DH”在@“LDH”之中，那么返回YES
 */
+ (BOOL)isString:(NSString*)oldString containStringByFirstCharacterCompare:(NSString*)compareString;

+ (void)creatFilterArraryWithInputArrary:(NSArray*)inputArrary
                            filterString:(NSString*)filterString
                        filterDictionary:(NSMutableDictionary*)filterDic
                         outFilterArrary:(NSMutableArray*)outFilterArrary;

@end
