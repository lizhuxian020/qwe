//
//  UIColor+KMTUtils.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/10.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KMTUtils)
#pragma mark --颜色相关方法
+ (UIColor *) colorWithHexString: (NSString *)hexColor;//颜色转换 IOS中十六进制的颜色转换为UIColor
@end
