//
//  UILabel+KMTInit.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (KMTInit)
+(instancetype)initWithLabe:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color font:(UIFont *)font textColor:(UIColor *)textClolor;

+(instancetype)initWithLabe:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color font:(UIFont *)font textColor:(UIColor *)textClolor andTextAligment:(NSTextAlignment)aligment;

+(UILabel *)initLabelWithFrame:(CGRect)frame andFont:(UIFont *)font andTextColor:(UIColor *)textColor andBackgroudColor:(UIColor *)backGroundColor andText:(NSString *)text andTextAligment:(NSTextAlignment)aligment;
@end
