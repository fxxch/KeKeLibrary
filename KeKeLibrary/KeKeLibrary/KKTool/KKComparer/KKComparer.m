//
//  KKComparer.m
//  KANJI
//
//  Created by liubo on 13-3-31.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKComparer.h"
#import "KKCategory.h"

@implementation KKComparer

//【数据Tableview分组】
+ (void)arraryGroupedByFirstCharacter:(NSArray *)inputArrary
                              withKey:(NSString*)key
                     outPutDictionary:(NSMutableDictionary*)outDic
                 outPutDictionaryKeys:(NSMutableArray*)outDicKeys
{
    if (key && inputArrary && outDic && outDicKeys) {
        
        [outDic removeAllObjects];
        [outDicKeys removeAllObjects];
        
        for (NSDictionary * dic in inputArrary) {
            NSString* name = [dic validStringForKey:key];
            if ([NSString isStringNotEmpty:name]) {
                unichar code = [[name substringToIndex:1] characterAtIndex:0];//获取第一个字符的UniCode
                char firstLetter = pinyinFirstLetter(code);//根据UniCode，获取字符
                
                NSString* firstLetterkey = [NSString stringWithFormat:@"%c",firstLetter];
                NSMutableArray* names = [outDic objectForKey:[firstLetterkey uppercaseString]];
                if (!names) {
                    names = [NSMutableArray array];
                }
                [names addObject:dic];
                [outDic setObject:names forKey:[firstLetterkey uppercaseString]];
            }
            else{
                continue;
            }
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
        NSArray* sortArray = [[NSArray alloc] initWithObjects:&descriptor count:1];
        [outDicKeys addObjectsFromArray:[[outDic allKeys] sortedArrayUsingDescriptors:sortArray]];
    }
}


+ (BOOL)isDictionary:(NSDictionary*)dictionary objectForKey:(NSString*)key containStringByFirstCharacterCompare:(NSString*)compareString{
    
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSString class]] || ![compareString isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ((dictionary && [dictionary count]>0) && key && ![key isEqualToString:@""] && compareString && ![compareString isEqualToString:@""]) {
        NSString* oldString = [[dictionary objectForKey:key] trimAllSpace];
        
        return [KKComparer isString:oldString containStringByFirstCharacterCompare:compareString];
    }
    else{
        return NO;
    }
}



+ (BOOL)isString:(NSString*)oldString containStringByFirstCharacterCompare:(NSString*)compareString{
    //生成原始字符串的首字母字符串 如：刘德华---》生成：@"LDH"
    if (![oldString isKindOfClass:[NSString class]]) {
        return NO;
    }
    oldString = [oldString trimAllSpace];
    NSString* oldLetterString = @"";
    if (oldString) {
        for (int m=0;m<[oldString length];m++) {
            NSRange range;
            range.location=m;
            range.length = 1;
            
            unichar code = [[oldString substringWithRange:range] characterAtIndex:0];//获取第一个字符的UniCode
            char firstLetter = characterFirstLetter(code);//根据UniCode，获取字符
            
            NSString* firstLetterkey = [NSString stringWithFormat:@"%c",firstLetter];
            oldLetterString = [oldLetterString stringByAppendingString:[firstLetterkey uppercaseString]];
        }
    }
    
    //生成新字符串的首字母字符串 如：刘德华---》生成：@"LDH"
    NSString* newString = [compareString trimAllSpace];
    NSString* newLetterString = @"";
    if (newString) {
        for (int m=0;m<[newString length];m++) {
            NSRange range;
            range.location=m;
            range.length = 1;
            
            unichar code = [[newString substringWithRange:range] characterAtIndex:0];//获取第一个字符的UniCode
            char firstLetter = characterFirstLetter(code);//根据UniCode，获取字符
            
            NSString* firstLetterkey = [NSString stringWithFormat:@"%c",firstLetter];
            newLetterString = [newLetterString stringByAppendingString:[firstLetterkey uppercaseString]];
        }
    }
    
    //开始过滤
    NSRange foundObj=[oldLetterString rangeOfString:newLetterString options:NSCaseInsensitiveSearch];
    if (foundObj.length>0) {
        return YES;
    }
    else{
        return NO;
    }
}














































//********************【创建过滤字典】 参数说明 ********************
/*【创建过滤字典】
 1、inputArrary         原始数据对象群
 2、filterKey           数据对象源对象中用于过滤的关键字段
 3、outFilterDictionary 生成之后的过滤字典
 */
//******************** 应用举例 ********************
/*
 例如：
 原数组（inputArrary）：
 1.[NSDictionary dictionaryWithObjectsAndKeys:@"张三丰",@"trueName",@"11",@"Age", nil];
 2.[NSDictionary dictionaryWithObjectsAndKeys:@"刘德华",@"trueName",@"6",@"Age", nil];
 3.[NSDictionary dictionaryWithObjectsAndKeys:@"李峰",@"trueName",@"12",@"Age", nil];
 
 关键字key：@"trueName"
 
 输出字典（outFilterDictionary）：{
 @"zsf张三丰",@"01",
 @"lzh刘德华",@"02",
 @"lf李峰",@"03",
 }
 */
+ (void)creatFilterDictionaryWithInputArrary:(NSArray *)inputArrary
                                   filterKey:(NSString*)filterKey
                         outFilterDictionary:(NSMutableDictionary*)outFilterDictionary{
    if (filterKey && (inputArrary && ([inputArrary count]>0)) && outFilterDictionary) {
                
        for (int i=0; i<[inputArrary count]; i++) {
            NSObject *obj = [inputArrary objectAtIndex:i];
            if (![obj isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            NSDictionary *dic = (NSDictionary*)[inputArrary objectAtIndex:i];
            NSString* name = [dic validStringForKey:filterKey];
            NSString *newName = [name trimAllSpace];
            
            NSString* newValue = @"";
            if (newName) {
                for (int m=0;m<[newName length];m++) {
                    NSRange range;
                    range.location=m;
                    range.length = 1;
                    
                    unichar code = [[newName substringWithRange:range] characterAtIndex:0];//获取第一个字符的UniCode
                    char firstLetter = characterFirstLetter(code);//根据UniCode，获取字符
                    
                    NSString* firstLetterkey = [NSString stringWithFormat:@"%c",firstLetter];
                    newValue = [newValue stringByAppendingString:[firstLetterkey uppercaseString]];
                }
            }
            newValue = [newValue stringByAppendingString:newName?newName:@""];
            
            [outFilterDictionary setObject:newValue forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
}


//********************【开始过滤】 参数说明 ********************
/*【开始过滤】
 1、inputArrary      过滤之前的原始数据对象群
 2、filterString     用于过滤的String
 3、filterDic        过滤字典
 4、outFilterArrary  过滤之后的数据对象群
 */
//******************** 应用举例 ********************
/*
 例如：
 原数组（inputArrary）：
 1.[NSDictionary dictionaryWithObjectsAndKeys:@"张三丰",@"trueName",@"11",@"Age", nil];
 2.[NSDictionary dictionaryWithObjectsAndKeys:@"刘德华",@"trueName",@"6",@"Age", nil];
 3.[NSDictionary dictionaryWithObjectsAndKeys:@"李峰",@"trueName",@"12",@"Age", nil];
 
 用于过滤的String(filterString)：@"L"
 
 输入过滤字典（outFilterDictionary）：{
 @"zsf张三丰",@"01",
 @"lzh刘德华",@"02",
 @"lf李峰",@"03",
 }
 
 输出数组：（NSMutableArray）{ //@"张三丰"由于这三个字的开始字母都不含有L，所以不被保留，而另外两个里面至少有一个字首个字母是L，所以被保留下来。
 @"lzh刘德华",@"02",
 @"lf李峰",@"03",
 }
 */
+ (void)creatFilterArraryWithInputArrary:(NSArray*)inputArrary
                            filterString:(NSString*)filterString
                        filterDictionary:(NSMutableDictionary*)filterDic
                         outFilterArrary:(NSMutableArray*)outFilterArrary{    
    if (inputArrary && filterDic && (filterString && ![filterString isEqualToString:@""]) && outFilterArrary) {
        [outFilterArrary removeAllObjects];
        
        NSString *tempFilterString = [[filterString trimAllSpace] uppercaseString];
        
        for (int i=0; i<[inputArrary count]; i++) {
            NSString *flterRangeString = [filterDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            if (flterRangeString) {
                NSRange foundObj=[flterRangeString rangeOfString:tempFilterString options:NSCaseInsensitiveSearch];
                if (foundObj.length>0) {
                    [outFilterArrary addObject:[inputArrary objectAtIndex:i]];
                }
            }
        }
    }
}


@end
