//
//  KMTBusinessTool.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseTool.h"

@interface KMTBusinessTool : KMTBaseTool


/**
 退出登录

 @param completed 完成回调
 */
+(void)unLoginWithCompleted:(void(^)(void))completed;

@end
