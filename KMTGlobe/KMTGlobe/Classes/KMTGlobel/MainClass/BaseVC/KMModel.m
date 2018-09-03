
//
//  KMModel.m
//  KMTPay
//
//  Created by 康美通 on 16/1/27.
//  Copyright © 2016年 KM. All rights reserved.
//

#import "KMModel.h"
#import <objc/runtime.h>

@implementation KMModel

//重写KVC的方法
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNull class]]) {
        [self setValue:@"" forKey:key];
    }else if ([value isKindOfClass:[NSNumber class]]){
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key{
    // NSLog(@"未找到相对应的KEY:%@",key);
    return nil;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }else if ([key isEqualToString:@"union"]) {
        [self setValue:value forKey:@"UNION"];
    }else{
      //  NSLog(@"未找到相对应的KEY:%@",key);
    }
}

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    id model = [[self alloc] init];
    unsigned int count = 0;
    //拿到成员变量列表
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *keyName = ivar_getName(ivar);
        //拿到成员变量名
        NSString *key = [NSString stringWithUTF8String:keyName];
        //去除开头的_
        key = [key substringFromIndex:1];
        id value = [dic objectForKey:key];
        if (value) {
            [model setValue:value forKey:key];
        }
    }
    return model;
}

@end
