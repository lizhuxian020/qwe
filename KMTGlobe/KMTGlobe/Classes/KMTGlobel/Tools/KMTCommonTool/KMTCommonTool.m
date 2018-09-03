//
//  KMTCommonTool.m
//  KMDeparture
//
//  Created by mac on 11/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTCommonTool.h"

@implementation KMTCommonTool

+ (instancetype)shareTool {
    static KMTCommonTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[KMTCommonTool alloc] init];
    });
    return tool;
}

- (NSString *)findImage:(NSString *)imgName {
    NSString *realImgName = nil;
    if (UI_IS_IPHONE6P && UI_IS_IPHONEX) {
        realImgName = [NSString stringWithFormat:@"%@@3x", imgName];
    } else {
        realImgName = [NSString stringWithFormat:@"%@@2x", imgName];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:realImgName ofType:@"png"];
    if (!path) {
        realImgName = [NSString stringWithFormat:@"%@", imgName];
        NSString *path = [[NSBundle mainBundle] pathForResource:realImgName ofType:@"png"];
        if (!path) {
            NSLog(@"======>WARN: cannot find image: %@", imgName);
            return nil;
        }
    }
    return path;
}

- (NSString *)getDateString:(NSString *)formate interval:(id)interval {
    if (![interval respondsToSelector:@selector(doubleValue)]) return @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[interval doubleValue]/1000];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formate;
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    format.timeZone = zone;
    
    return [format stringFromDate:date];
}

- (NSString *)getTimeStampWithFormate:(NSString *)formate dateStr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

- (BOOL)isEmpty:(id)obj {
    if (!obj) return YES;
    if ([obj isKindOfClass:NSString.class]) {
        NSString *str = obj;
        return str.checkEmpty;
    }
    if ([obj isKindOfClass:NSArray.class]) {
        NSArray *arr = obj;
        return arr.count <= 0;
    }
    if ([obj isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = obj;
        return [self isEmpty:dic.allKeys];
    }
    return NO;
}


- (NSRange)validateString:(NSString *)text regex:(NSString *)regexStr
{
    if (!regexStr || regexStr.length == 0) {
        return NSMakeRange(0, 0);
    }
    NSError *error;
    // 创建NSRegularExpression对象并指定正则表达式
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexStr
                                  options:0
                                  error:&error];
    if (!error) { // 如果没有错误
        // 获取特特定字符串的范围
        NSRange range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
        if (range.location == NSNotFound) {
            return NSMakeRange(0, 0);
        }
        return range;
    } else { // 如果有错误，则把错误打印出来
        return NSMakeRange(0, 0);
    }
    
}

- (void)callPhone:(NSString *)phoneNum {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (CGFloat)getOneFontHeight:(UIFont *)font {
    NSString *text = @"劳资就一行";
    CGSize size = [text stringheightWithFont:font andWidth:ScreenWidth];
    return size.height;
}

- (UIImage *)resizableImage:(UIImage *)image
                        top:(CGFloat)top
                     bottom:(CGFloat)bottom
                       left:(CGFloat)left
                      right:(CGFloat)right {
    
    // 设置端盖的值
    CGFloat t_top = image.size.height * top;
    CGFloat t_left = image.size.width * left;
    CGFloat t_bottom = image.size.height * bottom;
    CGFloat t_right = image.size.width * right;
    
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(t_top, t_left, t_bottom, t_right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

- (void)pasteString:(NSString *)str {
    ShowToast(@"复制成功");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
}

- (id)convertJSONFile:(NSString *)fileName {
    NSString *path = [NSBundle.mainBundle pathForResource:fileName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

- (NSString *)getJSONStr:(id)obj {
    if (![obj isKindOfClass:NSDictionary.class] && ![obj isKindOfClass:NSArray.class]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}
@end
