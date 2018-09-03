//
//  KMTHttpTool.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/4.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseTool.h"



typedef enum: NSInteger{
    KMTVerificationCodeType_bindPhone,
    KMTVerificationCodeType_register,
    KMTVerificationCodeType_login,
    KMTVerificationCodeType_modifyLoginPWD,
}KMTVerificationCodeType;

@interface KMTHttpTool : KMTBaseTool


/**
 网络状态监测
 */
+ (void)isAvailableToNetworkWithBlock:(void(^)(BOOL isAvailable))block;



@end
