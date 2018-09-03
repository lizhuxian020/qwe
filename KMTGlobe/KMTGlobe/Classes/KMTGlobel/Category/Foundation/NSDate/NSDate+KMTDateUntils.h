//
//  NSDate+KMTDateUntils.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/20.
//  Copyright © 2018年 KMT. All rights reserved.
//



@interface NSDate (KMTDateUntils)


/**
 获取当前时间戳

 @return 时间戳字符串
 */
+ (NSString *)getTimeStamp;


/**
 计算两个时间间隔时间

 @param time1 时间戳1
 @param time2 时间戳2
 @return 间隔时间
 */
+ (NSString* )compareTwoTime:(long long)time1 time2:(long long)time2;


/**
 比较两个时间大小

 @param oneDay 时间一
 @param anotherDay 时间2
 @return 0、1、-1
 */
+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;


+(int)compareAndFormat:(NSString *)format OneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;
@end
