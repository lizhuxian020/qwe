//
//  UIButton+initialization.m
//  KMDepartureCourier
//
//  Created by 康美通 on 2018/6/7.
//  Copyright © 2018年 KMT. All rights reserved.
//

#import "UIButton+initialization.h"



@implementation UIButton (initialization)

+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image andTitle:(NSString *)title andTextColor:(UIColor *)textColor andFont:(UIFont *)font andAction:(void (^)(id))action{
    UIButton *btn =
    [self initWithFrame:frame andImage:image andSelectImage:nil andTitle:title andTitleFont:font andTextColor:textColor andBackGroundColor:nil andBackgroundImage:nil andAction:^(id sender) {
        if (action) {
            action(sender);
        }
    }];
    return btn;
}


+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)image andTitle:(NSString *)title andTextColor:(UIColor *)textColor andFont:(UIFont *)font andBtnType:(KMTBtnType)type andAction:(void(^)(id sender))action{
    switch (type) {
        case KMTBtnType_UIButton:
            {
                UIButton *btn =
                [self initWithFrame:frame andImage:image andSelectImage:nil andTitle:title andTitleFont:font andTextColor:textColor andBackGroundColor:nil andBackgroundImage:nil andAction:^(id sender) {
                    if (action) {
                        action(sender);
                    }
                }];
                return btn;
            }
            break;
        case KMTBtnType_HomeBottomBtn:
        {
            KMTHomeBottomBtn *btn = [self initWithCustomBtnWithFrame:frame andImage:image andSelectImage:nil andTitle:title andTitleFont:font andTextColor:textColor andBackGroundColor:nil andBackgroundImage:nil andAction:^(id sender) {
                if (action) {
                    action(sender);
                }
            }];
            return btn;
        }
        case KMTBtnType_HomeBottomCerten:
        {
            UIButton *btn = [self initWithFrame:frame andImage:image andSelectImage:nil andTitle:title andTitleFont:font andTextColor:textColor andBackGroundColor:nil andBackgroundImage:nil andAction:^(id sender) {
                if (action) action(sender);
            }];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = textColor.CGColor;
            btn.layer.cornerRadius = 18;
            btn.clipsToBounds = YES;
            return btn;
        }
            break;
        default:
            return [UIButton new];
            break;
    }
}



+(instancetype)initWithFrame:(CGRect)frame andImage:(NSString *)normalImage andSelectImage:(NSString *)selectedImage andTitle:(NSString *)btnTitle andTitleFont:(UIFont *)font andTextColor:(UIColor *)textColor andBackGroundColor:(UIColor *)backgroundColor andBackgroundImage:(NSString *)backgroundImage andAction:(void (^)(id))action{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    if (normalImage) [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (selectedImage) [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    if (backgroundImage) [btn setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    if (btnTitle) [btn setTitle:btnTitle forState:UIControlStateNormal];
    if (textColor) [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:font ? font : FONTSIZE(14)];
    [btn setBackgroundColor:backgroundColor ? backgroundColor : WHITECOLOR];
    [btn addAction:^(UIButton *btn) {
        if (action) {
            action(btn);
        }
    }];
    return btn;
}

+(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTextColor:(UIColor *)textColor  andFont:(UIFont *)font andBackgroundColor:(UIColor *)bgColor andAction:(void (^)(id))action{
    return [self initWithCustomBtnWithFrame:frame andImage:nil andSelectImage:nil andTitle:title andTitleFont:font andTextColor:textColor andBackGroundColor:bgColor andBackgroundImage:nil andAction:action];
}

+(instancetype)initWithCustomBtnWithFrame:(CGRect)frame andImage:(NSString *)normalImage andSelectImage:(NSString *)selectedImage andTitle:(NSString *)btnTitle andTitleFont:(UIFont *)font andTextColor:(UIColor *)textColor andBackGroundColor:(UIColor *)backgroundColor andBackgroundImage:(NSString *)backgroundImage andAction:(void (^)(id))action{
    KMTHomeBottomBtn *btn = [[KMTHomeBottomBtn alloc]initWithFrame:frame];
    if (normalImage) [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (selectedImage) [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    if (backgroundImage) [btn setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    if (btnTitle) [btn setTitle:btnTitle forState:UIControlStateNormal];
    if (textColor) [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:font ? font : FONTSIZE(14)];
    [btn setBackgroundColor:backgroundColor ? backgroundColor : WHITECOLOR];
    [btn addAction:^(UIButton *btn) {
        if (action) {
            action(btn);
        }
    }];
    return btn;
}

+(UIButton *)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTitleFont:(UIFont*)font andTextColor:(UIColor *)color andAction:(ButtonBlock)action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:font];
    [btn addAction:^(UIButton *btn) {
        if (action) {
            action(btn);
        }
    }];
    return btn;
}


@end
