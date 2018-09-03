//
//  UIView+KMTViewInit.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//



@interface UIView (KMTViewInit)
+(instancetype)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)color;


/**
 view添加旋转动画

 @param view 目标view
 */
+(void)addTransformAnnimationWithView:(id)view animationTime:(CGFloat)anitime;


/**
 移除动画

 @param view 目标View
 */
+(void)stopAnimationWithView:(id)view;
@end
