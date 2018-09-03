//
//  KMTRequest.h
//  KMDeparture
//
//  Created by mac on 24/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *KMTRequestErrorCode_Timeout          = @"900001";
static const NSString *KMTRequestErrorCode_ConnectError     = @"900002";
static const NSString *KMTRequestErrorCode_DecodeError      = @"900003";
static const NSString *KMTRequestErrorCode_UnknownError     = @"999999";

typedef void(^finishCallback)(NSDictionary *, NSString *);
typedef void(^errorCallback)(NSString *errorCode, NSString *message);
typedef void(^finalCallback)(void);

@class KMTRequest;

typedef KMTRequest *(^KMTStringBlock)(NSString *);

typedef KMTRequest *(^KMTDictionaryBlock)(NSDictionary *);

typedef KMTRequest *(^KMTBoolBlock)(BOOL);

typedef KMTRequest *(^KMTFinishCallbackBlock)(finishCallback);

typedef KMTRequest *(^KMTFinalErrorCallbackBlock)(errorCallback);

typedef KMTRequest *(^KMTFinalCallbackBlock)(finalCallback);

@interface KMTRequest : NSObject

//----------- required -----------//

/**
 设置SubURL
 */
@property(nonatomic, copy, readonly) KMTStringBlock setSubURL;

/**
 设置入参
 */
@property(nonatomic, copy, readonly) KMTDictionaryBlock setParams;

/**
 设置完成block
 */
@property(nonatomic, copy, readonly) KMTFinishCallbackBlock setFinishCallback;


//----------- optional -----------//

/**
 对error的执行, 可以缺省, 默认showToast
 */
@property(nonatomic, copy, readonly) KMTFinalErrorCallbackBlock setErrorCallback;

/**
 设置最后执行的block(无论是否成功都会执行)
 */
@property(nonatomic, copy, readonly) KMTFinalCallbackBlock setFinalCallback;

/**
 设置是否显示loading, 默认YES
 */
@property(nonatomic, copy, readonly) KMTBoolBlock setShowLoading;

/**
 设置是否需要合并通用参数(loginId, token), 默认YES
 */
@property(nonatomic, copy, readonly) KMTBoolBlock setCombineCommonParam;

/**
 设置是否需要检测登录态, 默认YES
 */
@property(nonatomic, copy, readonly) KMTBoolBlock setCheckLogin;

/**
 设置是否需要检查Data字段
 */
@property(nonatomic, copy, readonly) KMTBoolBlock setCheckData;

/**
 开始请求
 */
- (void)startRequest;

- (void)startRequestInGroup;
@end
