//
//  KKKeyChainManager.m
//  GouUseCore
//
//  Created by liubo on 2017/8/17.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKKeyChainManager.h"
#import "KeKeLibraryDefine.h"
#import "KKCategory.h"

@implementation KKKeyChainManager

#pragma mark- ==================================================
#pragma mark UUID
#pragma mark==================================================
+ (NSString*)UUID{

    [KKKeyChainManager removeObjectForKey:@"KKKeyChain_UUID"];
    
    NSString *uuid = [KKKeyChainManager readObjectForKey:@"KKKeyChain_UUID"];
    if (uuid &&
        [uuid isKindOfClass:[NSString class]] &&
        [uuid length]>0) {
        
        return uuid;
    }
    else{
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        BOOL result = [KKKeyChainManager saveOject:uuid forKey:@"KKKeyChain_UUID"];
        if (result) {
            return uuid;
        }
        else{
            return nil;
        }
    }
}

#pragma mark- ==================================================
#pragma mark 读写方法
#pragma mark==================================================
+ (BOOL)saveOject:(id)object forKey:(NSString *)key{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [KKKeyChainManager getKeychainQueryForKey:key];
    
    OSStatus deleteErr = noErr;

    //Delete old item before add new item
    deleteErr = SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    if (deleteErr!=noErr) {
        KKLog(@"keychainDeleteError: %ld",(long)deleteErr);
    }
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object]
                      forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus writeErr = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    if (writeErr != errSecSuccess) {
#ifdef DEBUG
        NSLog(@"Add KeyChain Item Error!!! Error Detail:%ld", (long)writeErr);
        [self outPutErrorCode:(long)writeErr functionName:[NSString stringWithFormat:@"%s",__FUNCTION__]];
#endif
        return NO;
    }
    else {
#ifdef DEBUG
        NSLog(@"Add KeyChain Item Success!!!");
#endif
        return YES;
    }
}

+ (id)readObjectForKey:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [KKKeyChainManager getKeychainQueryForKey:key];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    return ret;
}

+ (BOOL)removeObjectForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [KKKeyChainManager getKeychainQueryForKey:key];
    OSStatus deleteErr = noErr;
    deleteErr = SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    if (deleteErr != errSecSuccess) {
#ifdef DEBUG
        NSLog(@"delete UUID from KeyChain Error!!! Error code:%ld", (long)deleteErr);
        [self outPutErrorCode:(long)deleteErr functionName:[NSString stringWithFormat:@"%s",__FUNCTION__]];
#endif
        return NO;
    }
    else {
#ifdef DEBUG
        NSLog(@"delete success!!!");
#endif
    }
    return YES;
}


#pragma mark- ==================================================
#pragma mark 通用方法
#pragma mark==================================================
+ (void)outPutErrorCode:(NSInteger)errorCode functionName:(NSString*)functionName{
#ifdef DEBUG
    
    
    if (errorCode==errSecSuccess) {/* No error. */
        NSLog(@"%@  errSecSuccess",functionName);
    }
    else if (errorCode==errSecUnimplemented){/* Function or operation not implemented. */
        NSLog(@"%@  errSecUnimplemented",functionName);
    }
    else if (errorCode==errSecIO){/* I/O error (bummers)*/
        NSLog(@"%@  errSecIO",functionName);
    }
    else if (errorCode==errSecOpWr){/* file already open with write permission*/
        NSLog(@"%@  errSecOpWr",functionName);
    }
    else if (errorCode==errSecParam){/* One or more parameters passed to a function where not valid. */
        NSLog(@"%@  errSecParam",functionName);
    }
    else if (errorCode==errSecAllocate){/* Failed to allocate memory. */
        NSLog(@"%@  errSecAllocate",functionName);
    }
    else if (errorCode==errSecUserCanceled){/* User canceled the operation. */
        NSLog(@"%@  errSecUserCanceled",functionName);
    }
    else if (errorCode==errSecBadReq){/* Bad parameter or invalid state for operation. */
        NSLog(@"%@  errSecBadReq",functionName);
    }
    else if (errorCode==errSecInternalComponent){
        NSLog(@"%@  errSecInternalComponent",functionName);
    }
    else if (errorCode==errSecNotAvailable){/* No keychain is available. You may need to restart your computer. */
        NSLog(@"%@  errSecNotAvailable",functionName);
    }
    else if (errorCode==errSecDuplicateItem){/* The specified item already exists in the keychain. */
        NSLog(@"%@  errSecDuplicateItem",functionName);
    }
    else if (errorCode==errSecItemNotFound){/* The specified item could not be found in the keychain. */
        NSLog(@"%@  errSecItemNotFound",functionName);
    }
    else if (errorCode==errSecInteractionNotAllowed){/* User interaction is not allowed. */
        NSLog(@"%@  errSecInteractionNotAllowed",functionName);
    }
    else if (errorCode==errSecDecode){/* Unable to decode the provided data. */
        NSLog(@"%@  errSecDecode",functionName);
    }
    else if (errorCode==errSecAuthFailed){/* The user name or passphrase you entered is not correct. */
        NSLog(@"%@  errSecAuthFailed",functionName);
    }
    else{
        
    }
#endif
}

+ (NSString*)kKeyChainUDIDAccessGroup_Key{
    
    NSDictionary *bundleInformation = [[NSBundle mainBundle] infoDictionary];
    NSString *CFBundleName = [bundleInformation validStringForKey:@"CFBundleName"];
    NSString *CFBundleExecutable = [bundleInformation validStringForKey:@"CFBundleExecutable"];
    NSString *fileName0 = [NSString stringWithFormat:@"%@.entitlements",CFBundleName];
    NSString *fileName1 = [NSString stringWithFormat:@"%@.entitlements",CFBundleExecutable];
    
    NSString *filePath0 = [[NSBundle mainBundle] pathForResource:fileName0 ofType:nil];
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:fileName1 ofType:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath0]) {
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath0];
        NSAssert((dictionary && [dictionary isKindOfClass:[NSDictionary class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSArray *array = [dictionary objectForKey:@"keychain-access-groups"];
        NSAssert((array && [array isKindOfClass:[NSArray class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSAssert(([array count]>0), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSString *returnString = [array objectAtIndex:0];
        NSAssert((returnString && [returnString isKindOfClass:[NSString class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        return returnString;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:filePath1]) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath1];
        NSAssert((dictionary && [dictionary isKindOfClass:[NSDictionary class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSArray *array = [dictionary objectForKey:@"keychain-access-groups"];
        NSAssert((array && [array isKindOfClass:[NSArray class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSAssert(([array count]>0), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        NSString *returnString = [array objectAtIndex:0];
        NSAssert((returnString && [returnString isKindOfClass:[NSString class]]), @"kKeyChainUDIDAccessGroup_Key 获取失败");
        
        return returnString;
    }
    else{
        //        NSAssert(false, @"kKeyChainUDIDAccessGroup_Key 获取失败");
        return @"";
    }
}

+ (NSMutableDictionary *)getKeychainQueryForKey:(NSString *)akey{
    
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
    
    //密钥类型键 kSecClass
    [keychainQuery setObject:(__bridge_transfer id)kSecClassGenericPassword
                      forKey:(__bridge_transfer id)kSecClass];

    [keychainQuery setObject:akey
                      forKey:(__bridge_transfer id)kSecAttrService];

    [keychainQuery setObject:akey
                      forKey:(__bridge_transfer id)kSecAttrAccount];

    [keychainQuery setObject:(__bridge_transfer id)kSecAttrAccessibleAlwaysThisDeviceOnly
                      forKey:(__bridge_transfer id)kSecAttrAccessible];

    
    // The keychain access group attribute determines if this item can be shared
    // amongst multiple apps whose code signing entitlements contain the same keychain access group.
    NSString *accessGroup = [KKKeyChainManager kKeyChainUDIDAccessGroup_Key];
    if (accessGroup != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [keychainQuery setObject:accessGroup
                          forKey:(__bridge_transfer id)kSecAttrAccessGroup];
#endif
    }
    
    return keychainQuery;
}


@end

//iOS钥匙串KeyChain相关参数的说明 (2014-04-08 22:22:57)转载▼
//标签： ios钥匙串 keychain	分类： 我的Objective-C之旅——中级
#pragma mark- 密钥类型
//密钥类型键
//CFTypeRef kSecClass
//
//值
//CFTypeRef kSecClassGenericPassword            //一般密码
//CFTypeRef kSecClassInternetPassword           //网络密码
//CFTypeRef kSecClassCertificate                //证书
//CFTypeRef kSecClassKey                        //密钥
//CFTypeRef kSecClassIdentity                   //身份证书(带私钥的证书)

//
//不同类型的钥匙串项对应的属性不同
//
//一般密码
//kSecClassGenericPassword
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttrService
//kSecAttrGeneric

//网络密码
//kSecClassInternetPassword
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttrSecurityDomain
//kSecAttrServer
//kSecAttrProtocol
//kSecAttrAuthenticationType
//kSecAttrPort
//kSecAttrPath

//证书
//kSecClassCertificate
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCertificateType
//kSecAttrCertificateEncoding
//kSecAttrLabel
//kSecAttrSubject
//kSecAttrIssuer
//kSecAttrSerialNumber
//kSecAttrSubjectKeyID
//kSecAttrPublicKeyHash

//密钥
//kSecClassKey
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrKeyClass
//kSecAttrLabel
//kSecAttrApplicationLabel
//kSecAttrIsPermanent
//kSecAttrApplicationTag
//kSecAttrKeyType
//kSecAttrKeySizeInBits
//kSecAttrEffectiveKeySize
//kSecAttrCanEncrypt
//kSecAttrCanDecrypt
//kSecAttrCanDerive
//kSecAttrCanSign
//kSecAttrCanVerify
//kSecAttrCanWrap
//kSecAttrCanUnwrap

//身份证书(带私钥的证书)
//kSecClassIdentity
//
//对应属性
//   证书属性
//   私钥属性



#pragma mark- 属性
//键
//CFTypeRef kSecAttrAccessible;                                        //可访问性 类型透明
//值
//          CFTypeRef kSecAttrAccessibleWhenUnlocked;                  //解锁可访问，备份
//          CFTypeRef kSecAttrAccessibleAfterFirstUnlock;              //第一次解锁后可访问，备份
//          CFTypeRef kSecAttrAccessibleAlways;                        //一直可访问，备份
//          CFTypeRef kSecAttrAccessibleWhenUnlockedThisDeviceOnly;    //解锁可访问，不备份
//          CFTypeRef kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;//第一次解锁后可访问，不备份
//          CFTypeRef kSecAttrAccessibleAlwaysThisDeviceOnly;          //一直可访问，不备份

//CFTypeRef kSecAttrCreationDate;      //创建日期          CFDateRef
//CFTypeRef kSecAttrModificationDate;  //最后一次修改日期   CFDateRef
//CFTypeRef kSecAttrDescription;       //描述             CFStringRef
//CFTypeRef kSecAttrComment;           //注释             CFStringRef
//CFTypeRef kSecAttrCreator;           //创建者            CFNumberRef(4字符，如'aLXY')
//CFTypeRef kSecAttrType;              //类型             CFNumberRef(4字符，如'aTyp')
//CFTypeRef kSecAttrLabel;             //标签(给用户看)     CFStringRef
//CFTypeRef kSecAttrIsInvisible;       //是否隐藏          CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)
//CFTypeRef kSecAttrIsNegative;        //是否具有密码       CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)此项表示当前的item是否只是一个占位项，或者说是只有key没有value。
//CFTypeRef kSecAttrAccount;           //账户名            CFStringRef
//CFTypeRef kSecAttrService;           //所具有服务         CFStringRef
//CFTypeRef kSecAttrGeneric;           //用户自定义内容      CFDataRef
//CFTypeRef kSecAttrSecurityDomain;    //网络安全域         CFStringRef
//CFTypeRef kSecAttrServer;            //服务器域名或IP地址  CFStringRef

//键
//CFTypeRef kSecAttrProtocol;                      //协议类型 CFNumberRef
//          值
//          CFTypeRef kSecAttrProtocolFTP;         //
//          CFTypeRef kSecAttrProtocolFTPAccount;  //
//          CFTypeRef kSecAttrProtocolHTTP;        //
//          CFTypeRef kSecAttrProtocolIRC;         //
//          CFTypeRef kSecAttrProtocolNNTP;        //
//          CFTypeRef kSecAttrProtocolPOP3;        //
//          CFTypeRef kSecAttrProtocolSMTP;        //
//          CFTypeRef kSecAttrProtocolSOCKS;       //
//          CFTypeRef kSecAttrProtocolIMAP;        //
//          CFTypeRef kSecAttrProtocolLDAP;        //
//          CFTypeRef kSecAttrProtocolAppleTalk;   //
//          CFTypeRef kSecAttrProtocolAFP;         //
//          CFTypeRef kSecAttrProtocolTelnet;      //
//          CFTypeRef kSecAttrProtocolSSH;         //
//          CFTypeRef kSecAttrProtocolFTPS;        //
//          CFTypeRef kSecAttrProtocolHTTPS;       //
//          CFTypeRef kSecAttrProtocolHTTPProxy;   //
//          CFTypeRef kSecAttrProtocolHTTPSProxy;  //
//          CFTypeRef kSecAttrProtocolFTPProxy;    //
//          CFTypeRef kSecAttrProtocolSMB;         //
//          CFTypeRef kSecAttrProtocolRTSP;        //
//          CFTypeRef kSecAttrProtocolRTSPProxy;   //
//          CFTypeRef kSecAttrProtocolDAAP;        //
//          CFTypeRef kSecAttrProtocolEPPC;        //
//          CFTypeRef kSecAttrProtocolIPP;         //
//          CFTypeRef kSecAttrProtocolNNTPS;       //
//          CFTypeRef kSecAttrProtocolLDAPS;       //
//          CFTypeRef kSecAttrProtocolTelnetS;     //
//          CFTypeRef kSecAttrProtocolIMAPS;       //
//          CFTypeRef kSecAttrProtocolIRCS;        //
//          CFTypeRef kSecAttrProtocolPOP3S;       //

//键
//CFTypeRef kSecAttrAuthenticationType;                      //认证类型 CFNumberRef
//          值
//          CFTypeRef kSecAttrAuthenticationTypeNTLM;        //
//          CFTypeRef kSecAttrAuthenticationTypeMSN;         //
//          CFTypeRef kSecAttrAuthenticationTypeDPA;         //
//          CFTypeRef kSecAttrAuthenticationTypeRPA;         //
//          CFTypeRef kSecAttrAuthenticationTypeHTTPBasic;   //
//          CFTypeRef kSecAttrAuthenticationTypeHTTPDigest;  //
//          CFTypeRef kSecAttrAuthenticationTypeHTMLForm;    //
//          CFTypeRef kSecAttrAuthenticationTypeDefault;     //

//CFTypeRef kSecAttrPort;                 //网络端口           CFNumberRef
//CFTypeRef kSecAttrPath;                 //访问路径           CFStringRef
//CFTypeRef kSecAttrSubject;              //X.500主题名称      CFDataRef
//CFTypeRef kSecAttrIssuer;               //X.500发行者名称     CFDataRef
//CFTypeRef kSecAttrSerialNumber;         //序列号             CFDataRef
//CFTypeRef kSecAttrSubjectKeyID;         //主题ID             CFDataRef
//CFTypeRef kSecAttrPublicKeyHash;        //公钥Hash值         CFDataRef
//CFTypeRef kSecAttrCertificateType;      //证书类型            CFNumberRef
//CFTypeRef kSecAttrCertificateEncoding;  //证书编码类型        CFNumberRef

//CFTypeRef kSecAttrKeyClass;                     //加密密钥类  CFTypeRef
//          值
//          CFTypeRef kSecAttrKeyClassPublic;     //公钥
//          CFTypeRef kSecAttrKeyClassPrivate;    //私钥
//          CFTypeRef kSecAttrKeyClassSymmetric;  //对称密钥

//CFTypeRef kSecAttrApplicationLabel;  //标签(给程序使用)          CFStringRef(通常是公钥的Hash值)
//CFTypeRef kSecAttrIsPermanent;       //是否永久保存加密密钥       CFBooleanRef
//CFTypeRef kSecAttrApplicationTag;    //标签(私有标签数据)         CFDataRef

//CFTypeRef kSecAttrKeyType;  //加密密钥类型(算法)   CFNumberRef
//          值
//          extern const CFTypeRef kSecAttrKeyTypeRSA;

//CFTypeRef kSecAttrKeySizeInBits;     //密钥总位数               CFNumberRef
//CFTypeRef kSecAttrEffectiveKeySize;  //密钥有效位数              CFNumberRef
//CFTypeRef kSecAttrCanEncrypt;        //密钥是否可用于加密         CFBooleanRef
//CFTypeRef kSecAttrCanDecrypt;        //密钥是否可用于加密         CFBooleanRef
//CFTypeRef kSecAttrCanDerive;         //密钥是否可用于导出其他密钥   CFBooleanRef
//CFTypeRef kSecAttrCanSign;           //密钥是否可用于数字签名      CFBooleanRef
//CFTypeRef kSecAttrCanVerify;         //密钥是否可用于验证数字签名   CFBooleanRef
//CFTypeRef kSecAttrCanWrap;           //密钥是否可用于打包其他密钥   CFBooleanRef
//CFTypeRef kSecAttrCanUnwrap;         //密钥是否可用于解包其他密钥   CFBooleanRef
//CFTypeRef kSecAttrAccessGroup;       //访问组                   CFStringRef


#pragma mark- 搜索
//CFTypeRef kSecMatchPolicy;                 //指定策略            SecPolicyRef
//CFTypeRef kSecMatchItemList;               //指定搜索范围         CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。仍然会搜索钥匙串，但是搜索结果需要与该数组取交集作为最终结果。
//CFTypeRef kSecMatchSearchList;             //
//CFTypeRef kSecMatchIssuers;                //指定发行人数组       CFArrayRef
//CFTypeRef kSecMatchEmailAddressIfPresent;  //指定邮件地址         CFStringRef
//CFTypeRef kSecMatchSubjectContains;        //指定主题            CFStringRef
//CFTypeRef kSecMatchCaseInsensitive;        //指定是否不区分大小写  CFBooleanRef(kCFBooleanFalse或不提供此参数,区分大小写;kCFBooleanTrue,不区分大小写)
//CFTypeRef kSecMatchTrustedOnly;            //指定只搜索可信证书    CFBooleanRef(kCFBooleanFalse或不提供此参数,全部证书;kCFBooleanTrue,只搜索可信证书)
//CFTypeRef kSecMatchValidOnDate;            //指定有效日期         CFDateRef(kCFNull表示今天)
//CFTypeRef kSecMatchLimit;                  //指定结果数量         CFNumberRef(kSecMatchLimitOne;kSecMatchLimitAll)
//CFTypeRef kSecMatchLimitOne;               //首条结果
//CFTypeRef kSecMatchLimitAll;               //全部结果


#pragma mark- 列表
//CFTypeRef kSecUseItemList;   //CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。用户提供用于查询的列表。当这个列表被提供的时候，不会再搜索钥匙串。


#pragma mark- 返回值类型
//可以同时指定多种返回值类型
//CFTypeRef kSecReturnData;           //返回数据(CFDataRef)                  CFBooleanRef
//CFTypeRef kSecReturnAttributes;     //返回属性字典(CFDictionaryRef)         CFBooleanRef
//CFTypeRef kSecReturnRef;            //返回实例(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef)         CFBooleanRef
//CFTypeRef kSecReturnPersistentRef;  //返回持久型实例(CFDataRef)             CFBooleanRef


#pragma mark- 写入值类型
//CFTypeRef kSecValueData;
//CFTypeRef kSecValueRef;
//CFTypeRef kSecValuePersistentRef;


