//
//  NSString+YM.m
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "NSString+YM.h"
#import <CommonCrypto/CommonDigest.h>
#import "AESCipher.h"

static NSString * const AESKEY = @"wsAc78qwnb34cvs8";

@implementation NSString (YM)

- (CGSize)stringSizeWithFont:(UIFont *)font preComputeSize:(CGSize)preSize {
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(preSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    
    return stringSize;
}




- (NSString *)md5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [[NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] uppercaseString];
}


-(NSString *)aesString{
    NSString *aesString = aesEncryptString(self, AESKEY);
    return aesString;
}



- (NSString *)urlInURLEncoding {
    
    NSString *encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedUrl;
}

- (NSUInteger)getBytesLength {
   NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

- (NSAttributedString *)stringToAttributedStringWithAttributedSubStrings:(NSArray *)attributedSubStrings attributedStyles:(NSArray *)attributedStyles {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    // 根据attributedSubStrings数组,找出子串在待富文本字符串中的位置
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSString *subString in attributedSubStrings) {
        NSRange subRange = [self rangeOfString:subString];
        [ranges addObject:NSStringFromRange(subRange)];
    }
    
    // 根据各子串及其样式属性将其设置为富文本
    for (NSInteger i=0; i<attributedSubStrings.count; i++) {
        NSRange subRange = NSRangeFromString(ranges[i]);
        NSDictionary *subAttributedStyle = attributedStyles[i];
        
        [attributedStr setAttributes:subAttributedStyle range:subRange];
    }
    
    return attributedStr;
}

// 去掉空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str
{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newStr = [[NSString alloc]initWithString:[str stringByTrimmingCharactersInSet:whiteSpace]];
    return newStr;
}

@end
