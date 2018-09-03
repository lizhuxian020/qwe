//
//  NSString+YM.h
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (YM)

// 根据文字属性计算当前文字所需尺寸
- (CGSize)stringSizeWithFont:(UIFont *)font preComputeSize:(CGSize)preSize;

// 对字符串md5加密
- (NSString *)md5String;

- (NSString *)aesString;

// URL编码
- (NSString *)urlInURLEncoding;

// 获取字符串的字节长
- (NSUInteger)getBytesLength;

// 将字符串中的子串转变为富文本
- (NSAttributedString *)stringToAttributedStringWithAttributedSubStrings:(NSArray *)attributedSubStrings attributedStyles:(NSArray *)attributedStyles;

// 去掉空格符
+ (NSString *)deteleTheBlankWithString:(NSString *)str;

@end
