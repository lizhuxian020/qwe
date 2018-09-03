//
//  KMTMapViewManager.h
//  KMDeparture
//
//  Created by 康美通 on 2018/6/1.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTBaseManager.h"
#import "KMTMapView.h"
//#import "CustomCalloutView.h"

typedef void(^getPCDSuccessedBlock)(NSString *province,NSString *city,NSString *destrict);

typedef void(^regionDidChangeAnimatedBlock)(MAMapView *map,BOOL animated);
typedef void(^didUpdateUserLocationBlock)(MAMapView *mapView,MAUserLocation *userLocation,BOOL updatingLocation);
typedef void(^setAnntationViewTitleBlock)(MAMapView* customCalloutView);
@interface KMTMapViewManager : KMTBaseManager



/**
 地图区域改变完成后回调
 */
@property(nonatomic,copy)regionDidChangeAnimatedBlock regionDidChangeAnimatedBlock;

/**
 位置或者设备方向更新后回调
 */
@property(nonatomic,copy)didUpdateUserLocationBlock didUpdateUserLocationBlock;


/**
 设置标注标题回调
 */
@property(nonatomic,copy) setAnntationViewTitleBlock  setAnntationViewTitleBlock ;

/**
 用户位置显示title
 */
@property(nonatomic,assign)NSString* userAnnotationViewTitle;


+(instancetype)shareMapViewManager;


-(KMTMapView *)createMapView;

//创建小蓝点
-(void)createUserLocationRepresentation;

/**
 创建定位按钮
 
 @param frame 位置坐标
 */
-(void)createUserLocationBtnWithFrame:(CGRect)frame;

/**
 设置地图中心点
 */
-(void)setMapViewCenterCoordinate:(CLLocationCoordinate2D)coordinate;


/**
 在viewDidAppera方法里面配置用户位置自定义标记
 */
-(void)userLocationViewConfig;



/**
 起点标记
 @param coordinate 起点经纬度
 */
-(void)addStartAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate;


/**
 终点标记

 @param coordinate 终点经纬度
 */
-(void)addEndAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate;


/**
 添加标记

 @param title 标记标题
 @param coordinate 经纬度
 */
-(void)addAnnotationWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate;


/**
 路线规划
 */
- (void)searchRoutePlanningRideWithBlock:(void(^)(id))action;


/**
 距离查询

 @param origins 起点集合
 @param destination 终点
 */
-(void)searchDistanceWithOrigins:(NSArray<AMapGeoPoint *> *)origins andEnd:(AMapGeoPoint *)destination;

-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views;

#pragma mark -------- 地理编码

/**
 根据经纬度获取城市

 @param coordinate 经纬度
 @param action 获取到回调
 */
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate andAction:(void(^)(NSString *cityName))action;

//根据经纬度返回省市区
-(void)searchPCDWithCoordinate:(CLLocationCoordinate2D)coordinate andAction:(getPCDSuccessedBlock)action;


#pragma mark -------- 根据经纬度获取周边信息
- (void)searchPoiByCenterCoordinate:(CLLocation *)location building:(NSString *)building withClass:(NSString *)className;
@end
