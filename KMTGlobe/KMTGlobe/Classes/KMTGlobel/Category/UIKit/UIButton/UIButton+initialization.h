//
//  UIButton+initialization.h
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonBlock)(UIButton* btn);
typedef enum : NSUInteger {
    KMTBtnType_UIButton,
    KMTBtnType_HomeBottomBtn,
    KMTBtnType_HomeBottomCerten,
} KMTBtnType;

@interface UIButton (initialization)

+(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTextColor:(UIColor *)textColor andFont:(UIFont *)font andBackgroundColor:(UIColor *)bgColor andAction:(void(^)(id sender))action;

+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image andTitle:(NSString *)title andTextColor:(UIColor *)textColor andFont:(UIFont *)font andAction:(void(^)(id sender))action;

+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image andTitle:(NSString *)title andTextColor:(UIColor *)textColor andFont:(UIFont *)font andBtnType:(KMTBtnType)type andAction:(void(^)(id sender))action;

+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)normalImage andSelectImage:(NSString *)selectedImage andTitle:(NSString *)btnTitle andTitleFont:(UIFont *)font andTextColor:(UIColor *)textColor andBackGroundColor:(UIColor *)backgroundColor andBackgroundImage:(NSString *)backgroundImage andAction:(void(^)(id sender))action;

+(UIButton *)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleFont:(UIFont*)font andTextColor:(UIColor *)color andAction:(ButtonBlock)action;

@end
