//
//  KMTLocationManager.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface KMTLocationManager : KMTBaseManager

+(instancetype)shareLocationManager;

-(void)locationManagerStartLoaction;

-(void)locationManagerStopLoaction;

- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock;

-(void)updateLoacationFailed:(void(^)(NSError *error))failed;

-(void)updateLoacationSuccessed:(void(^)(CLLocation *location))successed;


/**
 更新后台经纬度
 */
-(void)updateLocationInforWithNet;

/**
 计算两个经纬度之间的距离

 @param fromLoc 经纬度1
 @param toLoc 经纬度2
 @return 距离
 */
-(CGFloat)calculatTwoCoordinateDistanceWithLocFrom:(CLLocationCoordinate2D)fromLoc andToLoc:(CLLocationCoordinate2D)toLoc;


@end
