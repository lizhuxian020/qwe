//
//  KMTCustomAnnotationView.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/19.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface KMTCustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end
