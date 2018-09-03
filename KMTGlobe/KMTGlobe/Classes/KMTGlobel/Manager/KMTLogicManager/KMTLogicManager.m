//
//  KMTLogicManager.m
//  KMDeparture
//
//  Created by 康美通 on 2018/6/4.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTLogicManager.h"

@interface KMTLogicManager()

@property(nonatomic,strong)KMTMapViewManager *mapViewManager;
@property(nonatomic,strong)KMTUserInforModel *userInfoModel;
@property(nonatomic,strong)KMTLocationManager *locationManager;
@end

@implementation KMTLogicManager

+(instancetype)shareLogicManager{
    static KMTLogicManager *logic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logic = [[self alloc]init];
    });
    return logic;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _userInfoModel = [KMTUserInforModel shareUserInforManage];
    }
    return self;
}

+(void)load{
    //初始化第三方API
    [self configThirdAPI];
}

+(void)configThirdAPI{
//    [AMapServices sharedServices].apiKey = APIKey_Map;
}



-(KMTUserInforModel *)getUserInforModel{
    return _userInfoModel;
}

-(KMTLocationManager *)getLocationManager{
    _locationManager = [KMTLocationManager shareLocationManager];
    return _locationManager;
}



@end
