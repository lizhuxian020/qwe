//
//  KMTMapViewManager.m
//  KMDeparture
//
//  Created by 康美通 on 2018/6/1.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTMapViewManager.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"

typedef void(^getCitySuccessedBlock)(NSString *cityName);


static const NSInteger RoutePlanningPaddingEdge = 30;
static  NSString * const RoutePlanningViewControllerStartTitle       = @"起点";
static  NSString * const RoutePlanningViewControllerDestinationTitle = @"终点";

@interface KMTMapViewManager()<MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)KMTMapView *mapView;
@property(nonatomic,assign)CLLocationCoordinate2D centerPoint;//中心点获取到的经纬度
@property(nonatomic,assign)BOOL animated;
@property (strong, nonatomic) MAPointAnnotation *startAnnotation;
@property (strong, nonatomic) MAPointAnnotation *destinationAnnotation;
@property (assign, nonatomic) CLLocationCoordinate2D startCoordinate; //起始点经纬度
@property (assign, nonatomic) CLLocationCoordinate2D endCoordinate; //终点经纬度
@property (strong, nonatomic) AMapSearchAPI *search;  // 地图内的搜索API类
@property (strong, nonatomic) AMapRoute *route;  //路径规划信息
@property (strong, nonatomic) MANaviRoute * naviRoute;  //用于显示当前路线方案.
@property (assign, nonatomic) NSUInteger totalRouteNums;  //总共规划的线路的条数
@property (assign, nonatomic) NSUInteger currentRouteIndex; //当前显示线路的索引值，从0开始
@property(nonatomic,assign)NSInteger distance;//快递员当前与目的地的距离
@property(nonatomic,copy) getCitySuccessedBlock  getCityBlock ;
@property(nonatomic,copy) getPCDSuccessedBlock  getPCDBlock ;
@property(nonatomic,copy) void(^searchBlock)(id navi);
@property(nonatomic,copy) NSMutableArray *adressDateSource;
@property(nonatomic,copy) NSMutableArray  *tips;
@property(nonatomic,copy) NSString *  className;//用于标识哪个页面发起的搜索请求
@end

@implementation KMTMapViewManager

+(instancetype)shareMapViewManager{
    static KMTMapViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KMTMapViewManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMapView];
    }
    return self;
}

-(KMTMapView *)getMapView{
    return _mapView;
}


-(void)initMapView{
    [AMapServices sharedServices].enableHTTPS = true;
    _mapView = [[KMTMapView alloc]initWithFrame:Rect(0, 0, ScreenWidth, kMapViewHeight)];
    _mapView.delegate = self;
    _mapView.rotateCameraEnabled = false;
    _mapView.showsScale = false;
    _mapView.showsCompass = false;
    _mapView.showsUserLocation = true;
    _mapView.rotateEnabled = false;
    _mapView.maxZoomLevel = 19;
    _mapView.distanceFilter = 1;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:16];
//    [self createUserLocationBtn];
    //search
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self createUserLocationRepresentation];
}


-(void)createUserLocationRepresentation{
    //定位小蓝点自定义
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc]init];
    r.showsAccuracyRing = false;
    r.showsHeadingIndicator = true;
    r.fillColor = RGBA(1, 0, 0, 0.3);
    r.strokeColor = [UIColor lightGrayColor];
    r.lineWidth = 2.0f;
    r.image = [UIImage imageNamed:@"home_courier"];
    [_mapView updateUserLocationRepresentation:r];
}


-(KMTMapView *)createMapView{
    return _mapView;
}

-(void)createUserLocationBtnWithFrame:(CGRect)frame{
    KSELF
    UIImage *btnImage = Image(@"home_icon_get_position");
    UIButton *ret = [[UIButton alloc] initWithFrame:Rect(frame.origin.x, frame.origin.y, btnImage.size.width, btnImage.size.height)];
    ret.layer.cornerRadius = ret.width * 0.5;
    ret.layer.masksToBounds = true;
    ret.backgroundColor = [UIColor whiteColor];
    [ret setImage:btnImage forState:UIControlStateNormal];
    [ret addAction:^(UIButton *btn) {
        if(kself.mapView.userLocation.updating && kself.mapView.userLocation.location) {
            [kself.mapView setCenterCoordinate:kself.mapView.userLocation.location.coordinate animated:YES];
            [btn setSelected:YES];
        }
    }];
    [_mapView addSubview:ret];
}


-(void)createUserLocationBtn{
    UIImage *btnImage = Image(@"home_icon_get_position");
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(kSpace, kMapViewHeight - 60, btnImage.size.width, btnImage.size.height)];
    ret.layer.cornerRadius = ret.width * 0.5;
    ret.layer.masksToBounds = true;
    ret.backgroundColor = [UIColor whiteColor];
    [ret setImage:btnImage forState:UIControlStateNormal];
    KSELF
    [ret addAction:^(UIButton *btn) {
        if(kself.mapView.userLocation.updating && kself.mapView.userLocation.location) {
            [kself.mapView setCenterCoordinate:kself.mapView.userLocation.location.coordinate animated:YES];
            [btn setSelected:YES];
        }
    }];
    [_mapView addSubview:ret];
}

#pragma mark -- Public

-(void)setMapViewCenterCoordinate:(CLLocationCoordinate2D)coordinate{
    _mapView.centerCoordinate = coordinate;
    [_mapView reloadMap];
}


#pragma mark -- annotation
-(void)addStartAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self addAnnotationWithTitle:RoutePlanningViewControllerStartTitle andCoordinate:coordinate];
    self.startCoordinate = coordinate;
}

-(void)addEndAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self addAnnotationWithTitle:RoutePlanningViewControllerDestinationTitle andCoordinate:coordinate];
    self.endCoordinate = coordinate;
}

-(void)addAnnotationWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = coordinate;
    startAnnotation.title = (NSString *)title;
    [self.mapView addAnnotation:startAnnotation];
    
    if ([title isEqualToString:RoutePlanningViewControllerStartTitle]) {
        self.startAnnotation = startAnnotation;
    }else{
        self.destinationAnnotation = startAnnotation;;
    }
    
}



#pragma mark -- 路线规划
//骑行路线开始规划
- (void)searchRoutePlanningRideWithBlock:(void(^)(id))action {
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.strategy = 2;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.endCoordinate.latitude
                                                longitude:self.endCoordinate.longitude];
    
    
    [self.search AMapDrivingRouteSearch:navi];
    
    if (action) {
        self.searchBlock = action;
    }
}


-(void)searchDistanceWithOrigins:(NSArray<AMapGeoPoint *> *)origins andEnd:(AMapGeoPoint *)destination{
    AMapDistanceSearchRequest *req = [[AMapDistanceSearchRequest alloc]init];
    req.origins = origins;
    req.destination = destination;
    req.type = 1;
    [self.search AMapDistanceSearch:req];
}


#pragma mark -- AMapSearchDelegate

- (void)onDistanceSearchDone:(AMapDistanceSearchRequest *)request response:(AMapDistanceSearchResponse *)response{
    KMTLog(@"%@",response.results);
    if (response.results.count > 0) {
        AMapDistanceResult *result = response.results.firstObject;
        _distance = result.distance;
    }
}

//当路径规划搜索请求发生错误时，会调用代理的此方法
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    KMTLog(@"Error: %@", error);
    
}

//路径规划搜索完成回调.
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    
    if (response.route == nil){
        KMTLog(@"路径规划失败");
        return;
    }
    self.route = response.route;
    self.totalRouteNums = self.route.paths.count;
    self.currentRouteIndex = 0;
    [self presentCurrentRouteCourse];
    
}

//在地图上显示当前选择的路径
- (void)presentCurrentRouteCourse {
    
    
    if (self.totalRouteNums <= 0) {
        return;
    }
    
    [self.naviRoute removeFromMapView];  //清空地图上已有的路线
    
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentRouteIndex] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
    
    KSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [kself.mapView selectAnnotation:kself.mapView.userLocation animated:true];
    });
    
    
}

#pragma mark - MAMapViewDelegate

//地图上覆盖物的渲染，可以设置路径线路的宽度，颜色等
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    
    //虚线，如需要步行的
    if ([overlay isKindOfClass:[LineDashPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth = 6;
        polylineRenderer.lineDashType = kMALineDashTypeDot;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    
    //showTraffic为NO时，不需要带实时路况，路径为单一颜色
    if ([overlay isKindOfClass:[MANaviPolyline class]]) {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 6;
       
        if (naviPolyline.type == MANaviAnnotationTypeWalking) {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        } else if (naviPolyline.type == MANaviAnnotationTypeRailway) {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        } else {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        polylineRenderer.strokeColor = WHITECOLOR;
        return polylineRenderer;
    }
    
    //showTraffic为YES时，需要带实时路况，路径为多颜色渐变
    if ([overlay isKindOfClass:[MAMultiPolyline class]]) {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:(MAMultiPolyline *)overlay];
        
        polylineRenderer.lineWidth = 6;
        polylineRenderer.strokeColors = @[kMapViewRoadColor];
        
        return polylineRenderer;
    }
    
    return nil;
}



-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.regionDidChangeAnimatedBlock) self.regionDidChangeAnimatedBlock(mapView, animated);
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (self.didUpdateUserLocationBlock) self.didUpdateUserLocationBlock(mapView, userLocation, updatingLocation);
}




-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"home_courier"];
        annotationView.canShowCallout = YES;
        annotationView.annotation = annotation;

//        CustomCalloutView *callView = [[CustomCalloutView alloc]initWithFrame:Rect(0, 0, 180, 35) title:mapView.userLocation.title];//TOOD
        id callView;
        annotationView.customCalloutView = (MACustomCalloutView *)callView;
        if(annotation == mapView.userLocation) annotationView.customCalloutView.tag = 1001;
        
        //起点.
        if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
        {
            annotationView.image = Image(@"order_icon_location_consignee");
            annotationView.canShowCallout = false;
        }
        //终点.
        else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
        {
            annotationView.image = Image(@"order_icon_location_shipper");
            annotationView.canShowCallout = false;
        }
        return annotationView;
    }
    return nil;
}




-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    if ([views[0] isKindOfClass:MAAnnotationView.class]){
        MAPinAnnotationView *mapAnno = (MAPinAnnotationView*)views.firstObject;
        [self.mapView selectAnnotation:mapAnno.annotation animated:true];
    }
}


#pragma mark -------- 逆地理编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate andAction:(void (^)(NSString *))action
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    
    self.getCityBlock = action;
}

-(void)searchPCDWithCoordinate:(CLLocationCoordinate2D)coordinate andAction:(getPCDSuccessedBlock)action{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    
    self.getPCDBlock = action;
}

#pragma mark -------- 逆地理编码回调失败
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *province = response.regeocode.addressComponent.province;
    NSString *city = response.regeocode.addressComponent.city;
    NSString *district = response.regeocode.addressComponent.district;
    if (city) {
        if(self.getCityBlock) self.getCityBlock(city);
    }
    
    if (province && city && district) {
        if(self.getPCDBlock){
            self.getPCDBlock(province, city, district);
            
        };
    }
}

#pragma mark -------- 根据经纬度获取周边信息
- (void)searchPoiByCenterCoordinate:(CLLocation *)location building:(NSString *)building withClass:(NSString *)className
{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.keywords = building;
    request.types = @"住宅|建筑";
    request.radius   = 1000;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch:request];
    self.className = className;
    
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    wSelf(kself)
    if (response.pois.count == 0)
    {
        return;
    }
    
    [self.adressDateSource removeAllObjects];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [kself.adressDateSource addObject:obj];
        
    }];
    
    [kNotificationCenter postNotificationName:locationResult object:nil userInfo:@{@"dateSource":self.adressDateSource,@"className":self.className}];
    
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }
    
    [self.tips setArray:response.tips];
    
    [kNotificationCenter postNotificationName:locationResult object:nil userInfo:@{@"dateSource":self.tips,@"className":self.className}];
}

#pragma mark -------- get
-(NSMutableArray *)adressDateSource{
    if (_adressDateSource == nil) {
        _adressDateSource = [[NSMutableArray alloc]init];
    }
    return _adressDateSource;
}

-(NSMutableArray *)tips{
    if (!_tips) {
        _tips = [[NSMutableArray alloc]init];
    }
    return _tips;
}


@end
