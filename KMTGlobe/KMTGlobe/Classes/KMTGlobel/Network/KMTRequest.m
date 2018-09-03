//
//  KMTRequest.m
//  KMDeparture
//
//  Created by mac on 24/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTRequest.h"

const NSString *RequestParam_loginId    = @"loginId";
const NSString *RequestParam_token      = @"token";

@interface KMTRequest()

@property(nonatomic, assign) BOOL showLoading;

@property(nonatomic, assign) BOOL combineCommonParam;

@property(nonatomic, assign) BOOL checkLogin;

@property(nonatomic, assign) BOOL checkData;

@property(nonatomic, copy) NSString *subURL;

@property(nonatomic, copy) NSDictionary *params;

@property(nonatomic, copy) finishCallback finishCallback;

@property(nonatomic, copy) errorCallback errorBLK;

@property(nonatomic, copy) finalCallback finalBLK;

@end

@implementation KMTRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showLoading = YES;
        self.combineCommonParam = YES;
        self.checkLogin = YES;
    }
    return self;
}

- (void)startRequestInGroup {
    //检查登录入参
    if (_checkLogin && ![self checkLoginValid]) {
        self.finalBLK();
        return;
    };
    //合并通用入参
    if (_combineCommonParam) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [mDic setObject:kLoginId ? kLoginId : @"" forKey:RequestParam_loginId];
        [mDic setObject:kToken_user ? kToken_user : @"" forKey:RequestParam_token];
        self.params = mDic.copy;
    }
    _showLoading ? [KMTProgressTool show] : nil;
    YMNetRequest *request = [YMNetRequest sharedYMNetRequest];
    //这里不能用kself, 这里需要被YMRequest强引用!
    [request startHttpRequestWithoutProcessErrorWithSubUrl:self.subURL parameters:self.params completionBlock:^(NSDictionary *resDic, NSError *error) {
        
        self.showLoading ? [KMTProgressTool dismiss] : nil;
        void(^normalblock)(void) = ^{
            
            //只有code为"0000"才能执行finishCallback
            if (resDic && !error && [[resDic jsonString:@"code"] isEqualToString:SUCESS]) {
                if (self.checkData &&( ![resDic.allKeys containsObject:@"data"] || (![resDic[@"data"] isKindOfClass:NSDictionary.class] && ![resDic[@"data"] isKindOfClass:NSArray.class]))) {
                    ShowToast(@"数据为空");
                    KMTLogError(@"======Error>>>>>>数据没有data字段: \nURL: %@, \nParam: %@, \nResponseObj:%@", self.subURL, self.params, resDic);
                    return ;
                }
                self.finishCallback(resDic, [resDic jsonString:@"code"]);
//                if (responseDicBLK) responseDicBLK(resDic);
                return;
            }
            
            //如果有dic, 则优先处理
            NSString *errorMessage, *errorCode;
            if (resDic) {
                errorMessage = [resDic jsonString:@"message"];
                errorCode = [resDic jsonString:@"code"];
                
                if (self.checkLogin) {
                    //这里统一处理登录CODE
                    if ([self isLoginCode:errorCode message:errorMessage]) return;
                }
            } else if (error) {
                //没有dic, 再看看error, 有则处理
                //不是KMT的CODE的ERROR, 返回提示信息
                switch (error.code) {
                    case NSURLErrorTimedOut: {
                        errorCode = (NSString *)KMTRequestErrorCode_Timeout;
                        errorMessage = @"网络连接超时";
                    }
                        break;
                    case NSURLErrorCannotConnectToHost:
                    case NSURLErrorBadServerResponse: {
                        errorCode = (NSString *)KMTRequestErrorCode_ConnectError;
                        errorMessage = @"网络连接失败";
                    }
                        break;
                    case NSURLErrorCannotDecodeContentData: {
                        errorCode = (NSString *)KMTRequestErrorCode_DecodeError;
                        errorMessage = @"数据解析失败";
                    }
                        break;
                    default: {
                        errorCode = (NSString *)KMTRequestErrorCode_UnknownError;
                        errorMessage = error.localizedDescription;
                    }
                        break;
                }
            } else {
                //没有dic, 也没有error ??
                errorCode = (NSString *)KMTRequestErrorCode_UnknownError;
                errorMessage = @"未知错误";
            }
            
            self.errorBLK(errorCode, errorMessage);
        };
        
        normalblock();
        self.finalBLK();
    }];
}

- (void)startRequestWithResponse:(void(^)(NSDictionary *))responseDicBLK{
    //检查登录入参
    if (_checkLogin && ![self checkLoginValid]) {
        self.finalBLK();
        return;
    };
    //合并通用入参
    if (_combineCommonParam) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [mDic setObject:kLoginId ? kLoginId : @"" forKey:RequestParam_loginId];
        [mDic setObject:kToken_user ? kToken_user : @"" forKey:RequestParam_token];
        self.params = mDic.copy;
    }
    _showLoading ? [KMTProgressTool show] : nil;
    YMNetRequest *request = [YMNetRequest sharedYMNetRequest];
    //这里不能用kself, 这里需要被YMRequest强引用!
    [request startHttpRequestWithoutProcessErrorWithSubUrl:self.subURL parameters:self.params completionBlock:^(NSDictionary *resDic, NSError *error) {
        
        self.showLoading ? [KMTProgressTool dismiss] : nil;
        void(^normalblock)(void) = ^{
            
            //只有code为"0000"才能执行finishCallback
            if (resDic && !error && [[resDic jsonString:@"code"] isEqualToString:SUCESS]) {
                if (self.checkData &&( ![resDic.allKeys containsObject:@"data"] || (![resDic[@"data"] isKindOfClass:NSDictionary.class] && ![resDic[@"data"] isKindOfClass:NSArray.class]))) {
                    ShowToast(@"数据为空");
                    KMTLogError(@"======Error>>>>>>数据没有data字段: \nURL: %@, \nParam: %@, \nResponseObj:%@", self.subURL, self.params, resDic);
                    return ;
                }
                self.finishCallback(resDic, [resDic jsonString:@"code"]);
                if (responseDicBLK) responseDicBLK(resDic);
                return;
            }
            
            //如果有dic, 则优先处理
            NSString *errorMessage, *errorCode;
            if (resDic) {
                errorMessage = [resDic jsonString:@"message"];
                errorCode = [resDic jsonString:@"code"];
                
                if (self.checkLogin) {
                    //这里统一处理登录CODE
                    if ([self isLoginCode:errorCode message:errorMessage]) return;
                }
            } else if (error) {
                //没有dic, 再看看error, 有则处理
                //不是KMT的CODE的ERROR, 返回提示信息
                switch (error.code) {
                    case NSURLErrorTimedOut: {
                        errorCode = (NSString *)KMTRequestErrorCode_Timeout;
                        errorMessage = @"网络连接超时";
                    }
                        break;
                    case NSURLErrorCannotConnectToHost:
                    case NSURLErrorBadServerResponse: {
                        errorCode = (NSString *)KMTRequestErrorCode_ConnectError;
                        errorMessage = @"网络连接失败";
                    }
                        break;
                    case NSURLErrorCannotDecodeContentData: {
                        errorCode = (NSString *)KMTRequestErrorCode_DecodeError;
                        errorMessage = @"数据解析失败";
                    }
                        break;
                    default: {
                        errorCode = (NSString *)KMTRequestErrorCode_UnknownError;
                        errorMessage = error.localizedDescription;
                    }
                        break;
                }
            } else {
                //没有dic, 也没有error ??
                errorCode = (NSString *)KMTRequestErrorCode_UnknownError;
                errorMessage = @"未知错误";
            }
            
            self.errorBLK(errorCode, errorMessage);
        };
        
        normalblock();
        self.finalBLK();
    }];
}

- (void)startRequest {
    [self startRequestWithResponse:nil];
}

- (BOOL)isLoginCode:(NSString *)code message:(NSString *)message {
    //会话过期，退出登录
    if ([code isEqualToString:@"10063"] ||
        [code isEqualToString:@"10005"] ||
        [code isEqualToString:@"10058"]) {
        ShowToast(message);
        //会话过期
        [self noticeLoginInvalid];
        return YES;
    }
    return NO;
}

- (BOOL)checkLoginValid {
    if ([kLoginId isEqualToString:@""] || !kLoginId || !kToken_user ||
        [kToken_user isEqualToString:@""]) {
        ShowToast(@"token失效");
        [self noticeLoginInvalid];
        return NO;
    }
    return YES;
}

- (void)noticeLoginInvalid {
    [[NSNotificationCenter defaultCenter]postNotificationName:TokenInvalid object:nil];
}


#pragma mark --BLOCK
- (KMTStringBlock)setSubURL {
    KSELF
    return ^(NSString *subURL) {
        kself.subURL = subURL;
        return kself;
    };
}

- (KMTDictionaryBlock)setParams {
    KSELF
    return ^(NSDictionary *params) {
        kself.params = params;
        return kself;
    };
}

- (KMTFinishCallbackBlock)setFinishCallback {
    KSELF
    return ^(finishCallback finishCallback){
        kself.finishCallback = finishCallback;
        return kself;
    };
}

- (KMTFinalErrorCallbackBlock)setErrorCallback {
    KSELF
    return ^(errorCallback errorBLK) {
        kself.errorBLK = errorBLK;
        return kself;
    };
}

- (KMTFinalCallbackBlock)setFinalCallback {
    KSELF
    return ^(finalCallback finalBLK) {
        kself.finalBLK = finalBLK;
        return kself;
    };
}

- (KMTBoolBlock)setShowLoading {
    KSELF
    return ^(BOOL flag) {
        kself.showLoading = flag;
        return kself;
    };
}

- (KMTBoolBlock)setCombineCommonParam {
    KSELF
    return ^(BOOL combineCommonParam) {
        kself.combineCommonParam = combineCommonParam;
        return kself;
    };
}

- (KMTBoolBlock)setCheckLogin {
    KSELF
    return ^(BOOL checkLogin) {
        kself.checkLogin = checkLogin;
        return kself;
    };
}

- (KMTBoolBlock)setCheckData {
    KSELF
    return ^(BOOL checkData) {
        kself.checkData = checkData;
        return kself;
    };
}


/**
 如果没有赋值, 则使用默认的Callback
 */
#pragma mark -- GET
- (finishCallback)finishCallback {
    if (_finishCallback) return _finishCallback;
    return ^(NSDictionary *resDic, NSString *resCode) {
        
    };
}

- (errorCallback)errorBLK {
    if (_errorBLK) return _errorBLK;
    return ^(NSString *errorCode, NSString *message) {
        ShowToast(message);
    };
}

- (finalCallback)finalBLK {
    if (_finalBLK) return _finalBLK;
    return ^{
        
    };
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
