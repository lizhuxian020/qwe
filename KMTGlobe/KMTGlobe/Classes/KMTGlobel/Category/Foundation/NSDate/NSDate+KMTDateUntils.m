//
//  NSDate+KMTDateUntils.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/20.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "NSDate+KMTDateUntils.h"

@implementation NSDate (KMTDateUntils)
+ (NSString *)getTimeStamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
    return timeSp;
}


+ (NSString* )compareTwoTime:(long long)time1 time2:(long long)time2
{
    NSTimeInterval balance = time2 /1000 - time1 /1000;
    NSString*timeString = [[NSString alloc]init];
    timeString = [NSString stringWithFormat:@"%f",balance / 60];
    timeString = [timeString substringToIndex:timeString.length - 7];
    NSInteger timeInt = [timeString intValue];
    if (timeInt <= 0) {
        return [NSString timeStringFromTimeStamp:time2 andFormat:nil];
    }
    NSInteger hour = timeInt / 60;
    NSInteger mint = timeInt % 60;
    if(hour == 0) {
        timeString = [NSString stringWithFormat:@"%ld分钟内取件",(long)mint];
    }else{
        if(mint == 0) {
            timeString = [NSString stringWithFormat:@"%ld小时内取件",(long)hour];
        }else{
            timeString = [NSString stringWithFormat:@"%ld小时%ld分钟内取件",(long)hour,(long)mint];
        }
    }
    return timeString;
}


+(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    KMTLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

//@"yyyy-MM-dd HH:mm:ss"
+(int)compareAndFormat:(NSString *)format OneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    KMTLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

@end
