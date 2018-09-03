//
//  KMTLogicManager.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/4.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseManager.h"
#import "KMTUserInforModel.h"
#import "KMTLocationManager.h"
#define logicShareInstance   [KMTLogicManager shareLogicManager]


@interface KMTLogicManager : KMTBaseManager

+(instancetype)shareLogicManager;



-(KMTUserInforModel *)getUserInforModel;

-(KMTLocationManager *)getLocationManager;
@end
