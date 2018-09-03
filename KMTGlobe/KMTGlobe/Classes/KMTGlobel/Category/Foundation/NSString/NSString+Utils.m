//
//  NSString+Utils.m
//  SanLianOrdering
//
//  Created by shiqichao on 14-10-10.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import "NSString+Utils.h"
//正则表达式
#import <CommonCrypto/CommonDigest.h>
//catch exception
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <objc/runtime.h>

@implementation NSString (Utils)
//字符串去空格
-(NSString *)stringTrimWhitespace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//字符串去除空格
+(NSString *)stringDeleteWhiteSpaceWithString:(NSString *)string{
    return  [string stringByReplacingOccurrencesOfString:@" " withString:@""];;
}

#pragma mark --长度宽度相关方法
- (CGSize)stringWidthWithFont:(CGFloat)fontSize andText:(NSString *)text{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size;
    
}
//方法功能：计算字符串高度长度
- (CGSize)stringWidthWithFontSize:(CGFloat)fontSize andHeight:(CGFloat)height{
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0) {
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        return [self boundingRectWithSize:CGSizeMake(ScreenWidth, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    }else{
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(ScreenWidth, height)];
    }
}
//根据指定宽度，计算字符串高度
-(CGSize)stringheightWithFontSize:(CGFloat)fontSize andWidth:(CGFloat)width{
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0) {
        
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    }else{
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, 3000)];
    }
}

-(CGSize)stringheightWithFont:(UIFont *)font andWidth:(CGFloat)width {
    if ([UIDevice currentDevice].systemVersion.floatValue>7.0) {
        
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    }else{
        return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, 3000)];
    }
}

#pragma mark --时间相关方法
// 方法功能：时间戳
+ (NSString *)getTimeStamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}
// 获取格式化时间时间戳
- (NSString *)getTimeStampString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date=[dateFormatter dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
//取得格式化时间
-(NSString *)getDateTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateTimeStr = [dateFormatter stringFromDate:date];
    return dateTimeStr;
}
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}
+(NSString *)getPriousorLaterDateFromMonth:(NSInteger)month WithStarData:(NSString *)starDateStr

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *starDate = [formatter dateFromString:starDateStr];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:starDate options:0];
    
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:mDate];
    
    return currentTimeString;
    
}

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
+ (NSDate *)stringChangeDateWithDateString:(NSString *)dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}
//取得日期
-(NSString *)getDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[NSDate date];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)timeYMDHMFromTimeStamp:(NSTimeInterval) stamp{
    return [self timeStringFromTimeStamp:stamp andFormat:@"yyyy-MM-dd HH:mm"];
}
+(NSString *)timeHMFromTimeStamp{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return strHour;
}

+(NSString *)timeStringFromTimeStamp:(NSTimeInterval) stamp andFormat:(NSString *)format{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:stamp / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    if (!format) {
        format = @"yyyy-MM-dd HH:mm";
    }
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateTimeStr = [dateFormatter stringFromDate:date];
    return dateTimeStr;
}

#pragma mark --手机号码隐藏处理(加星号处理)
-(NSString *)securePhoneNumber{
    
    NSString *regular=@"(?<=\\d{4})\\d(?=\\d{4})";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:nil];
    
    NSString *content=self;
    content  = [regularExpression stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:@"*"];
    
    return content;
}
- (NSString *)secureLastFourCount:(NSString *)string{
    
    
    NSString *regular=@"(\\d(?=\\d{4}))";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:nil];
    
    string  = [regularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"*"];
    
    return string;
}
+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props =class_copyPropertyList([obj class], &propsCount);
    for(int i =0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value ==nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

-(NSString *)secureBankCardNumber{
    
    NSString *regular=@"(?<=\\d{4})\\d(?=\\d{4})";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:nil];
    
    NSString *content=self;
    content  = [regularExpression stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:@"*"];
    content = [self formatterBankCardNum:content];
    return content;
}
/**身份证号码隐藏处理(加星号处理)显示前6位*/
-(NSString *)secureIDCardNumber{
    NSString *regular=@"(?<=\\d{6})\\d(?=\\d{0})";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:nil];
    
    NSString *content=self;
    content  = [regularExpression stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:@"*"];
    return content;
}
-(NSString *)formatterBankCardNum:(NSString *)string
{
    NSString *tempStr=string;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}

+(NSString *)timeDistanceWithTimestamp:(NSTimeInterval)timestamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *components = [self timeDiffFromDate:date toDate:[NSDate date]];
    if (components.day>0) {
        return [self timeStringFromTimeStamp:timestamp andFormat:@"yyyy-MM-dd"];
    }else if (components.hour>0){
        return [NSString stringWithFormat:@"%ld小时前",components.hour];
    }else if (components.minute>0){
        return [NSString stringWithFormat:@"%ld分钟前",components.minute];
    }else{
        return @"1分钟前";
    }
    return @"";
}
//获取时间差
+(NSDateComponents *)timeDiffFromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate{
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components= [calendar components:unitFlags fromDate:startingDate toDate:resultDate options:0];
    return components;
}


#pragma mark --dictionaryToJson
+(NSString *)dictionaryToJsonStr:(id)dic
{
    if (dic==nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"JSON String = %@", jsonString);
    return jsonString;
}

#pragma mark -- dataFilePath
+(NSString *)dataFilePathWithFileName:(NSString *)fileName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSLog(@"%@",path);
    return filePath;
};


#pragma mark -- md5 加密
+ (NSString *)getMD5String:(NSString *)encodeString{
    const char *cStr = [encodeString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), (unsigned char *)result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
+(NSString *)formatBrushAmount:(NSString *)string{
    if(string == nil || [string checkEmpty]){
        return @"￥0.00";
    }
    if(string.length == 1){
        return [NSString stringWithFormat:@"￥0.0%@",string];
    }
    NSString *oneAmount = [string substringWithRange:NSMakeRange(0, string.length -2)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =kCFNumberFormatterCurrencyStyle;
    
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithUnsignedInteger:[oneAmount intValue]]];
    newAmount = [NSString stringWithFormat:@"%@.%@",[newAmount componentsSeparatedByString:@"."][0],[string substringWithRange:NSMakeRange(string.length -2,2)]];
    return newAmount;
}

+ (NSString *)formatAmount:(NSString *)string {
    if(string == nil || [string checkEmpty]){
        return @"0.00";
    }
    if(string.length == 1){
        return [NSString stringWithFormat:@"0.0%@",string];
    }
    
    NSString *oneAmount = nil;
    if ([[string substringToIndex:1] isEqualToString:@"-"]) {
        oneAmount = [string substringWithRange:NSMakeRange(1, string.length -3)];
    }else {
        oneAmount = [string substringWithRange:NSMakeRange(0, string.length -2)];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle =kCFNumberFormatterCurrencyStyle;
    
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithUnsignedInteger:[oneAmount intValue]]];
    newAmount = [newAmount substringFromIndex:1];
    newAmount = [NSString stringWithFormat:@"%@.%@",[newAmount componentsSeparatedByString:@"."][0],[string substringWithRange:NSMakeRange(string.length -2,2)]];
    if ([[string substringToIndex:1] isEqualToString:@"-"]) {
        newAmount = [NSString stringWithFormat:@"-%@",newAmount];
    }
    return newAmount;
}


+ (NSString *)stringWithFormatAmount:(double)amount{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    
    NSString *priceStr = [numFormatter stringFromNumber:[NSNumber numberWithDouble:amount]];
    return priceStr;
}
+(NSString *)formatCardNumber:(NSString *)string{
    NSMutableString *cardString = [[NSMutableString alloc]init];
    NSInteger count = string.length;
    NSInteger index = 0;
    while (count>4) {
        [cardString appendString:[string substringWithRange:NSMakeRange(index, 4)]];
        [cardString appendString:@" "];
        index = index + 4;
        count = count - 4;
    }
    
    if(count > 0){
        [cardString appendString:@" "];
        [cardString appendString:[string substringWithRange:NSMakeRange(index,string.length - index)]];
    }
    
    return cardString;
    
}//卡号格式化

#pragma mark --age
+(NSString *)getAgeWithtTmestamp:(NSTimeInterval)time{
    if (time == 0) {
        return @"";
    }
    NSDate *birDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components= [calendar components:unitFlags fromDate:birDate toDate:[NSDate date] options:0];
    
    NSInteger year = components.year;
    return [NSString stringWithFormat:@"%ld",year];
}

#pragma mark -- 字符串截取
+(NSString *)subStringWithChar:(char* )ch pos:(int) pos length:(int) length{
    char* pch=ch;
    //定义一个字符指针，指向传递进来的ch地址。
    char* subch=(char*)calloc(sizeof(char),length+1);
    //通过calloc来分配一个length长度的字符数组，返回的是字符指针。
    int i;
    //只有在C99下for循环中才可以声明变量，这里写在外面，提高兼容性。
    pch=pch+pos;
    //是pch指针指向pos位置。
    for(i=0;i<length;i++) {
        subch[i]=*(pch++);
        //循环遍历赋值数组。
    }
    subch[length]='\0';//加上字符串结束符。
    NSString *stringValue = [NSString stringWithCString:subch encoding:NSUTF8StringEncoding];
    return stringValue;
}
/// 此方法随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
+(NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    return [uuid lowercaseString];
}

//获取七牛tocken最新保存时间
+ (NSString *)getQiNiuSaveTime{
    NSString *tockenTime = nil;
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    tockenTime = [userDf objectForKey:@"LASTTOCKENTIME"];
    [userDf synchronize];
    return tockenTime;
}
//保存七牛tocken时间
+ (void)saveQiNiuTockenTime{
    NSString *currentTime = [NSString getTimeStamp];
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:currentTime forKey:@"LASTTOCKENTIME"];
    [userDf synchronize];
}
//+ (NSDictionary*)getObjectData:(id)obj
//{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    unsigned int propsCount;
//    objc_property_t *props =class_copyPropertyList([obj class], &propsCount);
//    for(int i =0;i < propsCount; i++)
//    {
//        objc_property_t prop = props[i];
//
//        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
//        id value = [obj valueForKey:propName];
//        if(value ==nil)
//        {
//            value = [NSNull null];
//        }
//        else
//        {
//            value = [self getObjectInternal:value];
//        }
//        [dic setObject:value forKey:propName];
//    }
//    return dic;
//}

+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj]options:options error:error];
}
+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i =0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]]atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
#pragma mark 比较时间差多少天
+ (NSInteger )calculationTimeDifference:(NSDate *)starDate endDate:(NSDate *)endDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents   * comp = [calendar components:NSCalendarUnitDay fromDate:starDate toDate:endDate options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

+(NSInteger)getIntegerNimberWithString:(NSString *)string{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int num;
    [scanner scanInt:&num];
    return num;
}

@end
