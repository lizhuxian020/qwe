//
//  KMTMapView.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>



@interface KMTMapView : MAMapView

-(instancetype)initWithFrame:(CGRect)frame;


/**
 添加定位按钮

 @param frame 按钮位置（仅x/y有效）
 */
-(void)createUserLocationBtnWithFrame:(CGRect)frame;


//设置当前位置为中心点
-(void)setMapViewCenterCoordinate:(CLLocationCoordinate2D)coordinate;




@end
