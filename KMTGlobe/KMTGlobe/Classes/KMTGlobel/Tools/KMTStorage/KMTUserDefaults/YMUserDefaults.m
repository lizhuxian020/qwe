//
//  YMUserDefaults.m
//  KMTPay
//
//  Created by 123 on 15/11/2.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "YMUserDefaults.h"

@implementation YMUserDefaults
+ (void)saveBool:(BOOL)value forKey:(NSString *)key {
    
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveStringObject:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([value isKindOfClass:[NSNumber class]]){
        [[NSUserDefaults standardUserDefaults] setObject:[value stringValue] forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        KMTLog(@"%@ is not kind of NSString/NSNumber Class", value);
    }
}

+ (void)saveArrayObject:(NSArray *)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSArray class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        KMTLog(@"%@ is not kind of NSArray Class", value);
    }
}

+ (void)saveDictionary:(NSDictionary *)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        KMTLog(@"%@ is not kind of NSDictionary Class", value);
    }
}

+ (BOOL)boolValueForKey:(NSString *)key {
    BOOL boolVaule = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    return boolVaule;
}

+ (NSString *)stringValueForKey:(NSString *)key {
    id stringValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([stringValue isKindOfClass:[NSString class]]) {
        return stringValue;
    } else {
        KMTLog(@"the %@'s value is not string value", key);
        return nil;
    }
}

+ (NSArray *)arrayValueForKey:(NSString *)key {
    id arrayValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([arrayValue isKindOfClass:[NSArray class]]) {
        return arrayValue;
    } else {
        KMTLog(@"the %@'s value is not array value", key);
        return nil;
    }
}

+ (NSDictionary *)dictionaryValueForKey:(NSString *)key {
    id dictionaryValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([dictionaryValue isKindOfClass:[NSDictionary class]]) {
        return dictionaryValue;
    } else {
        KMTLog(@"the %@'s value is not dictionary value", key);
        return nil;
    }
}

+ (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
