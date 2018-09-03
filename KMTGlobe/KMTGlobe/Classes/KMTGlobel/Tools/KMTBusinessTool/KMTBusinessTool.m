//
//  KMTBusinessTool.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBusinessTool.h"
//#import "JPUSHService.h"
//#import "Mehandler.h"
//#import "KMTHomeHandler.h"
#import "KMTBottomPopView.h"
#import "KMTPayApi.h"
#import "ShowPayMoneyPWDView.h"

@implementation KMTBusinessTool
+(void)unLoginWithCompleted:(void (^)(void))completed{
    //JPush设置别名
    NSSet *login = [[NSSet alloc]initWithObjects:kLoginId, nil];
//    [JPUSHService deleteTags:login completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//        KMTLog(@"————————————————————%@标签移除成功————————————————————————",iTags);
//    } seq:0];//TODO
    [YMUserDefaults saveStringObject:@"unlogin" forKey:kLOGINSTATUS];
    [YMUserDefaults removeObjectForKey:kUSERINFORKEY];
    [YMUserDefaults removeObjectForKey:kUSERHEADKEY];
    [YMUserDefaults removeObjectForKey:kUSERTELKEY];
    [[NSNotificationCenter defaultCenter]postNotificationName:TokenInvalid object:nil];
    if (completed) {
        completed();
    }
}



@end
