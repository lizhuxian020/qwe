//
//  KMTUserInforModel.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/13.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTUserInforModel.h"

@implementation KMTUserInforModel

+(instancetype)shareUserInforManage{
    static KMTUserInforModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[KMTUserInforModel alloc]init];
    });
    return model;
}

-(BOOL)isLogin{
    if ([self.loginId isEqualToString:@""] || self.loginId == nil || [self.loginId isKindOfClass:[NSNull class]]) {
        return false;
    }else{
        return true;
    }
}

-(NSString *)loginId{
    if (!_loginId) {
        NSDictionary *userInformatica = [YMUserDefaults dictionaryValueForKey:kUSERINFORKEY];
        _loginId = [userInformatica objectForKey:@"loginId"];
    }
    return _loginId;
}

-(NSString *)token{
    if (!_token) {
        NSDictionary *userInformatica = [YMUserDefaults dictionaryValueForKey:kUSERINFORKEY];
        _token = [userInformatica objectForKey:@"token"];
    }
    return _token;
}

-(NSString *)name{
    if (!_name) {
        NSDictionary *userInformatica = [YMUserDefaults dictionaryValueForKey:kUSERINFORKEY];
        _name = [userInformatica objectForKey:@"name"];
    }
    return _name;
}




-(NSString *)isRealCou{
    if (!_isRealCou) {
        NSDictionary *userInformatica = [YMUserDefaults dictionaryValueForKey:kUSERINFORKEY];
        _isRealCou = [userInformatica objectForKey:@"isRealCou"];
    }
    return _isRealCou;
}

//-(NSString *)head{
//    if (!_head) {
//        NSDictionary *userInformatica = [YMUserDefaults dictionaryValueForKey:kUSERINFORKEY];
//        _head = [userInformatica objectForKey:@"head"];
//    }
//    return _head;
//}

- (void)clear {
    unsigned int count = 0;
    //拿到成员变量列表
    Ivar *ivarList = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *keyName = ivar_getName(ivar);
        //拿到成员变量名
        NSString *key = [NSString stringWithUTF8String:keyName];
        //去除开头的_
        key = [key substringFromIndex:1];
        [self setValue:nil forKey:key];
    }
    NSMutableDictionary *userInfoCache = [NSMutableDictionary dictionaryWithDictionary:[YMUserDefaults dictionaryValueForKey:kUSERINFORKEY]];
    NSString *tokoen = [userInfoCache objectForKey:@"token"];
    if (!kIsEmpty(tokoen)) [userInfoCache removeObjectForKey:@"token"];
    [YMUserDefaults saveDictionary:userInfoCache.copy forKey:kUSERINFORKEY];
}
@end
