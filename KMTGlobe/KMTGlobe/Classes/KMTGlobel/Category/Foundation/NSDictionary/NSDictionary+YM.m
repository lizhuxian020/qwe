//
//  NSDictionary+YM.m
//  KMTPay
//
//  Created by 123 on 15/10/30.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "NSDictionary+YM.h"

@implementation NSDictionary (YM)

/**
 *  将http请求参数转变为key=value&key=value形式的字符串
 *
 *  @return key=value&key=value形式的字符串
 */
- (NSString *)stringFromDictionaryParameters {
    NSString *appendingStr = [NSMutableString string] ;
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [self allKeys];
        NSArray *sortedAllKeys = [keys sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString * obj1, NSString *obj2){
            if ([obj1 compare:obj2] == NSOrderedAscending) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];

        for (NSString *key in sortedAllKeys) {
            NSString *value = [self jsonString:key];
            appendingStr = [appendingStr stringByAppendingFormat:@"%@=%@",key,value];
        }
    }
    
    return appendingStr;
    
}

- (NSString *)jsonString:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return nil;
}

- (NSDictionary *)jsonDict:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    return nil;
}

- (NSArray *)jsonArray:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }
    return nil;
}

- (NSArray *)jsonStringArray:(NSString *)key {
    NSArray *array = [self jsonArray:key];
    BOOL invalid = NO;
    for (id item in array) {
        if (![item isKindOfClass:[NSString class]]) {
            invalid = YES;
            break;
        }
    }
    return invalid ? nil :array;
}

- (BOOL)jsonBool:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)jsonInteger:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return [object integerValue];
    }
    return 0;
}

- (long long)jsonLongLong:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return [object longLongValue];
    }
    return 0;
}

- (unsigned long long)jsonUnsignedLongLong:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return [object unsignedLongLongValue];
    }
    return 0;

}

- (double)jsonDouble:(NSString *)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
        return [object doubleValue];
    }
    return 0;
}

@end
