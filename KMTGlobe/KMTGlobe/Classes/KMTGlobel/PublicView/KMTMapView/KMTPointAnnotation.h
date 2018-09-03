//
//  KMTPointAnnotation.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/7/3.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface KMTPointAnnotation : MAPointAnnotation
@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) UIImage *image;

//可拓展多个属性
@end
