//
//  NSURL+KKCategory.h
//  YouJia
//
//  Created by liubo on 2018/7/18.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (KKCategory)

@end

/*
    (lldb) po url
    wanqiannative://brand:8888/brandDetail?brandId=634295414479280000
    
    (lldb) po [url scheme]
    wanqiannative
    
    (lldb) po [url resourceSpecifier]
    //brand:8888/brandDetail?brandId=634295414479280000
    
    (lldb) po [url host]
    brand
    
    (lldb) po [url port]
    8888
    
    (lldb) po [url user]
    nil
    (lldb) po [url password]
    nil
    (lldb) po [url path]
    /brandDetail
    
    (lldb) po [url fragment]
    nil
    (lldb) po [url parameterString]
    nil
    (lldb) po [url query]
    brandId=634295414479280000
    
    (lldb) po [url relativePath]
    /brandDetail
    
    (lldb)
*/
