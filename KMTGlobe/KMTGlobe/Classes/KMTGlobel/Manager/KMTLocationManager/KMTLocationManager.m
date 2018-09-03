//
//  KMTLocationManager.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTLocationManager.h"

@interface KMTLocationManager()<AMapLocationManagerDelegate>
@property(nonatomic,strong)AMapLocationManager *amLocationManager;
@property(nonatomic,copy)void(^updateSuccessed)(CLLocation *location);
@property(nonatomic,copy)void(^updateFaile)(NSError *error);
@property(nonatomic,assign)CLLocationCoordinate2D localCoordinate;//当前实时经纬度
@end

@implementation KMTLocationManager
+(instancetype)shareLocationManager{
    static KMTLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KMTLocationManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _amLocationManager = [[AMapLocationManager alloc]init];
        [_amLocationManager setDelegate:self];
        [_amLocationManager setPausesLocationUpdatesAutomatically:false];
        [_amLocationManager setAllowsBackgroundLocationUpdates:YES];
    }
    return self;
}

-(void)locationManagerStartLoaction{
    [_amLocationManager startUpdatingLocation];
}


-(void)locationManagerStopLoaction{
    [_amLocationManager stopUpdatingLocation];
}

-(void)updateLoacationFailed:(void (^)(NSError *))failed{
    _updateFaile = failed;
}

-(void)updateLoacationSuccessed:(void (^)(CLLocation *))successed{
    _updateSuccessed = successed;
}

- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock{
   return [_amLocationManager requestLocationWithReGeocode:withReGeocode completionBlock:completionBlock];
}

#pragma mark -- AMapLocationManagerDelegate
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    if (_updateFaile) {
        _updateFaile(error);
    }
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    if (_updateSuccessed) {
        _updateSuccessed(location);
    }
    _localCoordinate = location.coordinate;
}



#pragma mark -- tools
-(CGFloat)calculatTwoCoordinateDistanceWithLocFrom:(CLLocationCoordinate2D)fromLoc andToLoc:(CLLocationCoordinate2D)toLoc{
    MAMapPoint p1 = fromLoc.latitude ? MAMapPointForCoordinate(fromLoc) : MAMapPointForCoordinate(_localCoordinate);
    MAMapPoint p2 = MAMapPointForCoordinate(toLoc);
    CLLocationDistance distance =  MAMetersBetweenMapPoints(p1, p2);
    return distance;
}

#pragma mark -- net

-(void)updateLocationInforWithNet{
    [self locationManagerStartLoaction];
    [self updateLoacationFailed:^(NSError *error) {
        [KMTProgressTool showErrorWithStatus:@"定位失败，请检查是否开启定位权限！"];
    }];
    
    [self updateLoacationSuccessed:^(CLLocation *location) {
        CLLocationCoordinate2D coordinate = location.coordinate;
        NSString *longitude = StringFormat(@(coordinate.longitude));
        NSString *latitude = StringFormat(@(coordinate.latitude));
//        [YMUserDefaults saveArrayObject:@[latitude,longitude] forKey:kUSER_COORDINATE];
        [self updateCoordinate:longitude latitude:latitude];
        [kLogicManager.getLocationManager locationManagerStopLoaction];
    }];
}

-(void)updateCoordinate:(NSString *)longitude latitude:(NSString *)latitude{
//    [KMTOtherHandle requestUpLoadCoordinateWithLongitude: longitude latitude:latitude loginId:kLoginId token:kToken_user comleted:^(NSDictionary *resDic, YMHttpRequestCode resCode) {
//        if (resDic && resCode == kYMHttpRequestCodeSuccess) {
//            if ([[resDic jsonString:@"code"] isEqualToString:SUCESS]) {
//                KMTLog(@"--------------位置更新成功-------------------");
//            }
//
//        }
//    }];//TODO
}

#pragma mark -------- delegate



@end
