//
//  UIView+KMTViewInit.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "UIView+KMTViewInit.h"

@implementation UIView (KMTViewInit)
+(instancetype)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)color{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+(void)addTransformAnnimationWithView:(id)view animationTime:(CGFloat)anitime{
    UIView *aview = view;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = anitime;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [aview.layer addAnimation:animation forKey:nil];
    
}

+(void)stopAnimationWithView:(id)view{
    UIView *sview = view;
    [sview.layer removeAllAnimations];
}
@end
