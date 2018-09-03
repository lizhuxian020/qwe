//
//  UILabel+KMTInit.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/14.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "UILabel+KMTInit.h"

@implementation UILabel (KMTInit)
+(instancetype)initWithLabe:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color font:(UIFont *)font textColor:(UIColor *)textClolor{
   return [self initWithLabe:frame title:title backgroundColor:color font:font textColor:textClolor andTextAligment:0];
}

+(instancetype)initWithLabe:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color font:(UIFont *)font textColor:(UIColor *)textClolor andTextAligment:(NSTextAlignment)aligment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = color;
    label.font = font;
    label.text = title;
    label.textColor = textClolor;
    label.numberOfLines = 0;
    if (aligment) label.textAlignment = aligment;
    return label;
}

+(UILabel *)initLabelWithFrame:(CGRect)frame andFont:(UIFont *)font andTextColor:(UIColor *)textColor andBackgroudColor:(UIColor *)backGroundColor andText:(NSString *)text andTextAligment:(NSTextAlignment)aligment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    if (backGroundColor) label.backgroundColor = backGroundColor;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = aligment;
    return label;
}

@end
