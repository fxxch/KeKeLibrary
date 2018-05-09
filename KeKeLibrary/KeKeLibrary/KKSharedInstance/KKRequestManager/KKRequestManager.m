//
//  KKRequestManager.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestManager.h"
#import "KKNetWorkObserver.h"
#import "KKFormRequest.h"
#import "KKRequestParam.h"
#import "KKRequestSender.h"
#import "AFNetworking.h"
#import "AESCrypt.h"
#import "KKCategory.h"

#ifdef DEBUG //开发阶段
#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else //发布阶段
#define NSLog(...)
#endif

//#ifdef DEBUG
//
//#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
//
//#else
//
//#define NSLog(FORMAT, ...) nil
//
//#endif


@interface KKRequestManager ()<KKFormRequestDelegate>

@end

@implementation KKRequestManager
@synthesize requestList;
//@synthesize returnCodeDictionary;

+ (KKRequestManager *)defaultManager{
    static KKRequestManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (id)init{
    self = [super init];
    if (self) {
        requestList = [[NSMutableArray alloc]init];
//        NSString *returnCodePlistName = @"ReturnCode";
//        NSString *language = [self getPreferredLanguage];
//        NSString *plistName = [NSString stringWithFormat:@"%@(%@)",returnCodePlistName,language];
//        returnCodeDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
//        if (!returnCodeDictionary) {
//            returnCodeDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ReturnCode(zh-Hans)" ofType:@"plist"]];
//        }
    }
    return self;
}

///**
// *得到本机现在用的语言
// * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
// */
//- (NSString*)getPreferredLanguage{
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
//    NSString* preferredLang = [languages objectAtIndex:0];
//    return preferredLang;
//}
#pragma mark ==================================================
#pragma mark == 添加网络请求
#pragma mark ==================================================
+ (void)addRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier requestSender:(KKRequestSender *)requestSender{
    [[KKRequestManager defaultManager] sendRequestWithParam:param requestIndentifier:indentifier requestSender:(KKRequestSender *)requestSender];
}

- (void)sendRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier requestSender:(KKRequestSender *)requestSender{
    //有网络
    if ([KKNetWorkObserver sharedInstance].status != NotReachable) {
        if (!(param && indentifier && requestSender)) {
            return ;
        }
        
        [self clearRequestWithIdentifier:indentifier];

        KKFormRequest *newFormRequest = [[KKFormRequest alloc] init];
        [newFormRequest setDelegate:self];
        [newFormRequest startRequest:indentifier
                               param:param
                       requestSender:requestSender];
        [requestList addObject:newFormRequest];
        newFormRequest = nil;
    }
    //没网络
    else{
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        if (param && [param isKindOfClass:[KKRequestParam class]]) {
            [dictionary setObject:param forKey:@"KKRequestParam"];
        }
        if (indentifier && [indentifier isKindOfClass:[NSString class]]) {
            [dictionary setObject:indentifier forKey:@"requestIndentifier"];
        }
        if (requestSender && [requestSender isKindOfClass:[KKRequestSender class]]) {
            [dictionary setObject:requestSender forKey:@"KKRequestSender"];
        }
        
        [self performSelector:@selector(requestCannotSendWhenNotHaveNetwork:) withObject:dictionary afterDelay:0.5];
    }
}

- (void)cancelRequest:(NSString*)indentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:indentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
}

/**
 * 网络请求无法发送，因为没有网络
 */
- (void)requestCannotSendWhenNotHaveNetwork:(NSDictionary*)aInformation{
 
    
    KKRequestParam *param = [aInformation objectForKey:@"KKRequestParam"];
    NSString *indentifier = [aInformation objectForKey:@"requestIndentifier"];
    KKRequestSender *requestSender = [aInformation objectForKey:@"KKRequestSender"];
    
    KKFormRequest *newFormRequest = [[KKFormRequest alloc] init];
    [newFormRequest setDelegate:self];
    [newFormRequest setRequestIdentifier:indentifier
                                   param:param
                           requestSender:requestSender];
    
    NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
    [httpInfomation setObject:@"" forKey:httpCodeKey];
    [httpInfomation setObject:@"" forKey:httpMessageKey];
    [httpInfomation setObject:[NSString stringWithFormat:@"%@",param.urlString] forKey:httpResultURLKey];
    [httpInfomation setObject:NetworkNotReachableCode forKey:httpResultCodeKey];
    [httpInfomation setObject:@"网络连接异常" forKey:httpResultMessageKey];
    
    [self processRequestFinished:newFormRequest
                  httpInfomation:httpInfomation
                   requestResult:nil
                  responseString:nil];
}

#pragma mark ==================================================
#pragma mark == KKFormRequestDelegate
#pragma mark ==================================================
- (void)requestFinished:(KKFormRequest *)request result:(id)responseObject{
    KKFormRequest *formRequest = (KKFormRequest *)request;
    
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    NSError *error;
    
    NSString *response_String = nil;
    if ([responseObject isKindOfClass:[NSString class]]) {
        response_String = responseObject;
    }
    
    NSString *response_DecryptString = nil;
    if (response_String&&[response_String isKindOfClass:[NSString class]]) {
        NSDictionary *dicString = [NSJSONSerialization JSONObjectWithData:[response_String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (dicString && [dicString isKindOfClass:[NSDictionary class]]) {
            [resultDictionary setValuesForKeysWithDictionary:dicString];
        }
        else{
            if ([NSString isStringNotEmpty:formRequest.requestParam.encryptPassword]) {
                response_DecryptString = [AESCrypt decrypt:response_String
                                                  password:formRequest.requestParam.encryptPassword];
            }
            if (response_DecryptString&&[response_DecryptString isKindOfClass:[NSString class]]) {
                NSDictionary *dicDecryptString = [NSJSONSerialization JSONObjectWithData:[response_DecryptString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                if (dicDecryptString && [dicDecryptString isKindOfClass:[NSDictionary class]]) {
                    [resultDictionary setValuesForKeysWithDictionary:dicDecryptString];
                }
            }
        }
    }
    
    NSData *response_Data = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        response_Data = responseObject;
    }

    NSString *response_Data_String = nil;
    NSString *response_Data_DecryptString = nil;
    if ([resultDictionary count]==0) {
        if (response_Data && [response_Data isKindOfClass:[NSData class]]) {
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:response_Data options:NSJSONReadingMutableContainers error:&error];
            if (dicData && [dicData isKindOfClass:[NSDictionary class]]) {
                [resultDictionary setValuesForKeysWithDictionary:dicData];
            }
            else{
                response_Data_String = [[NSString alloc] initWithData:response_Data encoding:NSUTF8StringEncoding];
                if (response_Data_String&&[response_Data_String isKindOfClass:[NSString class]]) {
                    NSDictionary *dicString = [NSJSONSerialization JSONObjectWithData:[response_Data_String dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                    if (dicString && [dicString isKindOfClass:[NSDictionary class]]) {
                        [resultDictionary setValuesForKeysWithDictionary:dicString];
                    }
                    else{
                        if ([NSString isStringNotEmpty:formRequest.requestParam.encryptPassword]) {
                            response_Data_DecryptString = [AESCrypt decrypt:response_Data_String
                                                              password:formRequest.requestParam.encryptPassword];
                        }
                        if (response_Data_DecryptString&&[response_Data_DecryptString isKindOfClass:[NSString class]]) {
                            NSDictionary *dicDecryptString = [NSJSONSerialization JSONObjectWithData:[response_Data_DecryptString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                            if (dicDecryptString && [dicDecryptString isKindOfClass:[NSDictionary class]]) {
                                [resultDictionary setValuesForKeysWithDictionary:dicDecryptString];
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    if ([resultDictionary count]>0) {
        NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
//        [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
//        [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
        [httpInfomation setObject:request.requestParam.urlString forKey:httpResultURLKey];
        [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
        [httpInfomation setObject:@"请求成功,返回数据【正常】" forKey:httpResultMessageKey];
        
        [self processRequestFinished:formRequest
                      httpInfomation:httpInfomation
                       requestResult:resultDictionary
                      responseString:response_String];
        
#ifdef DEBUG
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"★★★★★★★★★★Request %@ Finished : \n %@ \n",formRequest.identifier,resultDictionary);
        }
#endif
    }
    else{
        if (response_Data==nil && response_String==nil) {
            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
//            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
//            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:request.requestParam.urlString forKey:httpResultURLKey];
            [httpInfomation setObject:httpResultEmptyCode forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功,返回数据【空】" forKey:httpResultMessageKey];
            
            [self processRequestFinished:formRequest
                          httpInfomation:httpInfomation
                           requestResult:nil
                          responseString:nil];
#ifdef DEBUG
            if (KKFormRequest_IsOpenLog) {
                NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】nil \n",formRequest.identifier);
            }
#endif
            [self saveCrashReport:@"" request:(KKFormRequest*)request];
            
        }
        else{
            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
//            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
//            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:request.requestParam.urlString forKey:httpResultURLKey];
            [httpInfomation setObject:httpResultParseErrorCode forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功,返回数据【无法解析】" forKey:httpResultMessageKey];
            
            [self processRequestFinished:formRequest
                          httpInfomation:httpInfomation
                           requestResult:nil
                          responseString:response_String];
            
#ifdef DEBUG
            if (KKFormRequest_IsOpenLog) {
                NSLog(@"★★★★★★★★★★Request %@ Finished : \n",formRequest.identifier);
            }
            if (response_String) {
                if (KKFormRequest_IsOpenLog) {
                    NSLog(@"%@\n",response_String);
                }
                [self saveCrashReport:response_String request:(KKFormRequest*)request];
            }
            else if (response_Data){
                if (KKFormRequest_IsOpenLog) {
                    NSLog(@"%@\n",response_Data_String);
                }
                [self saveCrashReport:response_Data_String request:(KKFormRequest*)request];
            }
            else{
                
            }
#endif
        }
    }
}

- (void)requestFailed:(KKFormRequest *)request error:(NSError*)aError{

    NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
    [httpInfomation setObject:[NSString stringWithFormat:@"%ld",(long)aError.code] forKey:httpCodeKey];
    [httpInfomation setObject:[NSString stringWithFormat:@"%@",aError.localizedDescription] forKey:httpMessageKey];
    [httpInfomation setObject:request.requestParam.urlString forKey:httpResultURLKey];
    [httpInfomation setObject:NetworkRequestFailed forKey:httpResultCodeKey];
    [httpInfomation setObject:@"网络请求失败" forKey:httpResultMessageKey];
    
    [self processRequestFinished:(KKFormRequest*)request
                  httpInfomation:httpInfomation
                   requestResult:nil
                  responseString:nil];
}

- (void)processRequestFinished:(KKFormRequest*)formRequest
                httpInfomation:(NSDictionary*)httpInfomation
                 requestResult:(id)requestResult
                responseString:(NSString*)aResponseString
{

    [self clearRequest:formRequest];
    KKRequestSender *requestSender = (KKRequestSender*)formRequest.requestSender;
    [requestSender receivedRequestFinished:formRequest
                            httpInfomation:(NSDictionary*)httpInfomation
                             requestResult:requestResult
                            responseString:aResponseString];
    
}

- (void)clearRequest:(KKFormRequest*)formRequest{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:((KKFormRequest*)formRequest).identifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
}

- (void)clearRequestWithIdentifier:(NSString*)aIdentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:aIdentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
}

//记录错误日志
- (void)saveCrashReport:(NSString*)aString request:(KKFormRequest *)request{
    
//    if ([request.identifier hasPrefix:CMD_CrashReport]) {
//        return;
//    }
//    
//    NSString *requestURL = [request.url absoluteString];
//    NSString *requestResult = aString;
//    
//    //当前App版本号
//    NSString *bundleVersion = [NSBundle bundleVersion];
//    
//    //当前手机系统版本号
//    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//    
//    //当前手机型号
//    NSString *deviceVersion = [[UIDevice currentDevice] deviceVersion];
//    
//    //手机别名： 用户定义的名称 （“spring sky”的 iPod）
//    NSString* userPhoneName = [[UIDevice currentDevice] name];
//    
//    //设备名称（iPhone OS）
//    NSString* deviceName = [[UIDevice currentDevice] systemName];
//    
//    NSMutableDictionary *appInfo = [NSMutableDictionary dictionary];
//    [appInfo setObject:bundleVersion forKey:@"bundleVersion"];
//    [appInfo setObject:systemVersion forKey:@"systemVersion"];
//    [appInfo setObject:deviceVersion forKey:@"deviceVersion"];
//    [appInfo setObject:userPhoneName forKey:@"userPhoneName"];
//    [appInfo setObject:deviceName forKey:@"deviceName"];
//    
//    NSDictionary *requestParam = request.requestParam.postParamDic;
//    NSString *requestParamString = [requestParam translateToJSONString];
//    
//    NSMutableDictionary *message = [NSMutableDictionary dictionary];
//    [message setObject:requestParamString?requestParamString:@"" forKey:@"requestPostParam"];
//    [message setObject:requestURL?requestURL:@"" forKey:@"requestURL"];
//    [message setObject:requestResult?requestResult:@"" forKey:@"requestResult"];
//    [message setObject:[NSString stringWithInteger:CrashReportType_APIInterface] forKey:@"exceptionType"];
//    [message setObject:appInfo?appInfo:@"" forKey:@"AppInfo"];
//    NSString *timestamp = [NSString stringWithFloat:[[NSDate date] timeIntervalSince1970]];
//    [message setObject:timestamp forKey:@"timestamp"];
//    NSString *dateString = [NSDate getStringWithFormatter:KKDateFormatter01];
//    [message setObject:dateString forKey:@"date"];
//
//    NSMutableDictionary *reportAll = [NSMutableDictionary dictionary];
//    NSDictionary *report = [KKUserDefaultsManager objectForKey:CrashReportInformation identifier:nil];
//    if ([NSDictionary isDictionaryNotEmpty:report]) {
//        [reportAll setValuesForKeysWithDictionary:report];
//    }
//    
//    [reportAll setObject:message forKey:timestamp];
//    
//    [KKUserDefaultsManager setObject:reportAll forKey:CrashReportInformation identifier:nil];
//    
//    [[NetWorkSender_Basic defaultSender] checkAndUploadCrashReport];
}



@end



