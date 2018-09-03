//
//  KMTButton.h
//  KMDeparture
//
//  Created by mac on 12/7/2018.
//  Copyright © 2018 KMT. All rights reserved.
//

#import "KMTView.h"

@class KMTButton;

typedef void(^didClickCallback) (KMTButton *);
typedef BOOL(^clickableBtnCallback) (KMTButton *);

@interface KMTButton : KMTView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *bgColor;


/**
 返回btn对象, 默认圆角

 @param title 文案
 @param color 文案颜色
 @param font 文案字体大小
 @param bgColor 背景颜色
 @param callback 点击回调
 @return 实例对象
 */
+ (instancetype)buttonWithTitle:(NSString *)title
                     titleColor:(UIColor *)color
                           font:(UIFont *)font
                        bgColor:(UIColor *)bgColor
                       didClick:(didClickCallback)callback;


/**
 设置能否点击, 默认可以点

 @param callback 返回能否点击的逻辑
 */
- (void)setClickable:(clickableBtnCallback)callback;

@end
