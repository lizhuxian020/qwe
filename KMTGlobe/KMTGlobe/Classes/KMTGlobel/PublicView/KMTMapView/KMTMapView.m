//
//  KMTMapView.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "KMTMapView.h"
#import "CustomCalloutView.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"



@interface KMTMapView()<MAMapViewDelegate,AMapSearchDelegate>
@property (strong, nonatomic) AMapSearchAPI *search;
@end

@implementation KMTMapView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self configMapView];
    }
    return self;
}

-(void)configMapView{
    [AMapServices sharedServices].enableHTTPS = true;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.showsCompass = false;
    self.showsScale = false;
    self.showsUserLocation = false;
    self.rotateCameraEnabled = false;
    self.rotateEnabled = false;
    self.userTrackingMode = MAUserTrackingModeFollow;
    [self createUserLocationRepresentation];
    
}


-(void)createUserLocationBtnWithFrame:(CGRect)frame{
    wSelf(kself)
    UIImage *btnImage = Image(@"home_icon_get_position");
    UIButton *ret = [[UIButton alloc] initWithFrame:Rect(frame.origin.x, frame.origin.y, btnImage.size.width, btnImage.size.height)];
    ret.layer.cornerRadius = ret.width * 0.5;
    ret.layer.masksToBounds = true;
    ret.backgroundColor = [UIColor whiteColor];
    [ret setImage:btnImage forState:UIControlStateNormal];
    [ret addAction:^(UIButton *btn) {
        if(kself.userLocation.updating && kself.userLocation.location) {
            [kself setCenterCoordinate:kself.userLocation.location.coordinate animated:kself];
            [btn setSelected:YES];
        }
    }];
    [self addSubview:ret];
}

////定位小蓝点自定义
-(void)createUserLocationRepresentation{
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc]init];
    r.showsAccuracyRing = false;
    r.showsHeadingIndicator = false;
    r.fillColor = RGBA(1, 0, 0, 0.3);
    r.strokeColor = [UIColor lightGrayColor];
    r.lineWidth = 2.0f;
    r.image = [UIImage imageNamed:@"home_courier"];
    [self updateUserLocationRepresentation:r];
}

-(void)setMapViewCenterCoordinate:(CLLocationCoordinate2D)coordinate{
    self.centerCoordinate = coordinate;
    [self reloadMap];
}



@end
