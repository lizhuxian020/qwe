//
//  NSString+Utils.h
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-10.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
#pragma mark --字符相关方法
- (NSString *)stringTrimWhitespace;//字符串去空格
+(NSString *)stringDeleteWhiteSpaceWithString:(NSString *)string;//字符串去除所有空格和换行
#pragma mark --长度宽度相关方法
///计算宽高
- (CGSize)stringWidthWithFont:(CGFloat)fontSize andText:(NSString *)text;
-(CGSize)stringWidthWithFontSize:(CGFloat)fontSize andHeight:(CGFloat)height; //获得UILabel在设置text后的真实长度
-(CGSize)stringheightWithFontSize:(CGFloat)fontSize andWidth:(CGFloat)width;//根据指定宽度，计算Label高度
-(CGSize)stringheightWithFont:(UIFont *)font andWidth:(CGFloat)width;//根据指定宽度，计算Label高度
+(NSString *)formatBrushAmount:(NSString *)string;//金额格式化
+ (NSString *)formatAmount:(NSString *)string;
+ (NSString *)stringWithFormatAmount:(double)amount;
+(NSString *)formatCardNumber:(NSString *)string;//卡号格式化
/// model转Dict
+ (NSDictionary*)getObjectData:(id)obj;
#pragma mark --时间相关方法
+(NSString*)getCurrentTimes;
//获取前多少个月的时间
+(NSString *)getPriousorLaterDateFromMonth:(NSInteger)month WithStarData:(NSString *)starDateStr;
+ (NSString *)getTimeStamp; // 获取时间戳
- (NSString *)getTimeStampString; // 获取格式化时间时间戳
- (NSString *)getDateTimeString;//取得格式化时间
- (NSString *)getDateString;//取得日期
///比较时间大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;

+(NSString *)timeYMDHMFromTimeStamp:(NSTimeInterval) stamp;
+(NSString *)timeHMFromTimeStamp;
+ (NSDate *)stringChangeDateWithDateString:(NSString *)dateString;
+(NSString *)timeStringFromTimeStamp:(NSTimeInterval) stamp andFormat:(NSString *)format;

#pragma mark --手机号码隐藏处理(加星号处理)
-(NSString *)securePhoneNumber;
#pragma mark 后四位处理
- (NSString *)secureLastFourCount:(NSString *)string;
+(NSString *)timeDistanceWithTimestamp:(NSTimeInterval)timestamp;
#pragma mark --dictionaryToJson
+(NSString *)dictionaryToJsonStr:(id)dic;

+(NSString *)dataFilePathWithFileName:(NSString *)fileName;

#pragma mark -- md5 加密
+ (NSString *)getMD5String:(NSString *)encodeString;

#pragma mark --age
+(NSString *)getAgeWithtTmestamp:(NSTimeInterval)time;

#pragma mark -- 字符串截取
+(NSString *)subStringWithChar:(char* )ch pos:(int) pos length:(int) length;
#pragma mark 比较时间差多少天
+ (NSInteger )calculationTimeDifference:(NSDate *)starDate endDate:(NSDate *)endDate;
+ (NSString *)getQiNiuSaveTime;
+ (void)saveQiNiuTockenTime;
/// 此方法随机产生32UUID位字符串。
+(NSString *)uuidString;

/**银行卡号码隐藏处理(加星号处理)*/
-(NSString *)secureBankCardNumber;
/**身份证号码隐藏处理(加星号处理)显示前6位*/
-(NSString *)secureIDCardNumber;

//提取字符串中的数字
+(float)getIntegerNimberWithString:(NSString *)string;

@end
