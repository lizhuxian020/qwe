//
//  YMUserDefaults.h
//  KMTPay
//
//  Created by 123 on 15/11/2.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMUserDefaults : NSObject

+ (void)saveBool:(BOOL)value forKey:(NSString *)key;
// 保存NSString与NSNumber类型
+ (void)saveStringObject:(id)value forKey:(NSString *)key;
+ (void)saveArrayObject:(NSArray *)value forKey:(NSString *)key;
+ (void)saveDictionary:(NSDictionary *)value forKey:(NSString *)key;

+ (BOOL)boolValueForKey:(NSString *)key;
+ (NSString *)stringValueForKey:(NSString *)key;
+ (NSArray *)arrayValueForKey:(NSString *)key;
+ (NSDictionary *)dictionaryValueForKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

@end
