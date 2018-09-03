//
//  KMTHttpTool.m
//  KMDeparture
//
//  Created by 康美通 on 2018/6/4.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTHttpTool.h"
#import "AFNetworkReachabilityManager.h"
//#import "KMTAccountHandler.h"

@implementation KMTHttpTool

+(void)isAvailableToNetworkWithBlock:(void (^)(BOOL))block{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch(status){
            case AFNetworkReachabilityStatusUnknown: if (block) block(false);
                break;
            case AFNetworkReachabilityStatusNotReachable: if (block) block(false);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: if (block) block(true);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: if (block) block(true);
        }
    }];
}



@end
