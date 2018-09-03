//
//  NSDictionary+YM.h
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YM)

// 将字典类型的参数转换为发送get请求时所需的拼接字符串
- (NSString *)stringFromDictionaryParameters;

- (NSString *)jsonString: (NSString *)key;
- (NSDictionary *)jsonDict: (NSString *)key;
- (NSArray *)jsonArray: (NSString *)key;

// 判断该数组中的每个对象是否都是字符串
- (NSArray *)jsonStringArray: (NSString *)key;

// 常规类型
- (BOOL)jsonBool: (NSString *)key;
- (NSInteger)jsonInteger: (NSString *)key;
- (long long)jsonLongLong: (NSString *)key;
- (unsigned long long)jsonUnsignedLongLong:(NSString *)key;
- (double)jsonDouble: (NSString *)key;


@end
