//
//  KMTRequestManager.m
//  AFNetworking
//
//  Created by mac on 22/8/2018.
//

#import "KMTRequestManager.h"

@interface KMTRequestManager()

@property(nonatomic, strong) NSMutableArray<KMTRequest *> * taskArray;

/**
 所有response, key:subURL, value:response
 */
@property(nonatomic, strong) NSMutableDictionary *allResponseDic;

@end

@implementation KMTRequestManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskArray = [NSMutableArray new];
        _allResponseDic = [NSMutableDictionary new];
    }
    return self;
}

+ (instancetype)shareManager {
    static KMTRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [KMTRequestManager new];
    });
    return manager;
}

- (void)addRequest:(KMTRequest *)reqeust {
    [_taskArray addObject:reqeust];
    reqeust.setShowLoading(NO);
}

- (void)stratReqeustWithFinishCallback:(KMTCallback)finishCallback {
    dispatch_group_t group = dispatch_group_create();

    [_taskArray enumerateObjectsUsingBlock:^(KMTRequest * _Nonnull request, NSUInteger idx, BOOL * _Nonnull stop) {

        /*
         [request startRequestInGorup: group callback:(^(BOOL success, Dic *dic){
         if (success) {
            [self.allResponse addObject: dic];
         } else {
            code = dic[@"code
            message=  dic[@"message
         }
         
         
         
         
         }];
         
         */
//
        
//        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//            //执行Request, 但是不能执行Request的callback, 并且还要拿到response
////            [request startRequestWithResponse:^(NSDictionary *responseDic) {
////                [self.allResponseDic setObject:responseDic forKey:@"request.subURL"];
////            }];
//
//            //拿到response, 储存起来
//        });
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        /*
         
         if (success) {
            successCallback(self.allResponse,)
         } else {
            errorCallback(self.allResponse, )
         }
         
         
         */
        [self.taskArray removeAllObjects];
        //这里要执行每个Request的Callback
        //执行finishCallback
        finishCallback(self.allResponseDic);
    });
}

- (void)cancelAllTask {
    
}
/*
 
 kmtreqeustmaneg new]
 .addReqeust(r1, r2, r3)
 .finishcallback:(^(nsdic *dic){
    ndisc = dic[subURL]
 }
 
*/

- (NSURLSessionDataTask *)request:(NSString *)subUrl
                                 :(NSDictionary *)parameters
                                 :(void(^)(NSDictionary *resDic, NSError *error))completionBlock
                                 :(dispatch_group_t)group  {
    //构建签名字符串
    NSString *signStr  = [self createSignStringWithSuburl:subUrl parameters:parameters];
    
    //对签名字符串进行md5签名
    NSString *signedStr = [signStr md5String];
    
    //组装请求参数
    NSDictionary *reqParaDic = nil;
    if (signedStr) {
        reqParaDic = [self createRequestParametersWithSuburl:subUrl signedStr:signedStr parameters:parameters];
    } else {
        NSLog(@"md5签名失败");
    }
    
    //响应回调
    void (^responseBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        
        //请求成功时返回的响应数据对象,错误时该对象为nil
        NSDictionary    *responseDic = (NSDictionary *)responseObject;
        //请求失败时返回的响应错误对象,正确时该对象为nil
        NSError         *responseError            = error;
        
        completionBlock(responseDic, responseError);
        
    };
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
    manager.securityPolicy = securityPolicy;
    //    manager.completionGroup = nil;
    //    manager.completionQueue
    
    KMTLog(@"请求参数:url===>%@ \n parameters===>%@",BaseUrl, [CommonTool getJSONStr:reqParaDic]);
    NSURLSessionDataTask *task = [manager POST:BaseUrl parameters:reqParaDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *json = [CommonTool getJSONStr:responseObject];
        KMTLog(@" \n ================ responseObject ================ \n%@",json);
        if (responseBlock) responseBlock(task, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        KMTLog(@"responseObject = %@",error);
        if (responseBlock) responseBlock(task, nil, error);
    }];
    return task;
}

#pragma mark - private
//构建签名字符串
- (NSString *)createSignStringWithSuburl:(NSString *)subUrl parameters:(NSDictionary *)parameters {
    
    //将需要签名的业务参数与协议参数组装在字典里
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setValue:subUrl forKey:@"method"];
    if (![[parameters allKeys] containsObject:@"v"]) {
        //如果传参中不包含接口版本，则使用默认的接口版本1.0.0
        [dic setValue:@"1.0.0" forKey:@"v"];
    }
    //风控参数/设置设备采集信息
    //    [dic setValue:[DeviceUtils getDeviceInfo] forKey:@"deviceFinger"];
    //由参数字典(含业务参数与协议参数)字符串化与签名key拼接构成
    NSString *signStr = [NSString stringWithFormat:@"%@%@", [dic stringFromDictionaryParameters], APP_MD5_KEY];
    return signStr;
}

//组装请求参数
- (NSDictionary *)createRequestParametersWithSuburl:(NSString *)subUrl signedStr:(NSString *)signedStr parameters:(NSDictionary *)parameters {
    NSMutableDictionary *requestParaDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParaDic setValue:subUrl forKey:@"method"];
    if (![[parameters allKeys] containsObject:@"v"]) {
        //如果传参中不包含接口版本，则覆盖默认的接口版本1.0.0
        [requestParaDic setValue:@"1.0.0" forKey:@"v"];
    }
    [requestParaDic setValue:signedStr forKey:@"sign"];
    //风控参数/设备采集信息
    //    [requestParaDic setValue:[DeviceUtils getDeviceInfo] forKey:@"deviceFinger"];
    return requestParaDic;
}

@end
