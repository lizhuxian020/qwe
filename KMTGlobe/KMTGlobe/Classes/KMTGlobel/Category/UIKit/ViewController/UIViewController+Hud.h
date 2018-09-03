//
//  UIViewController+Hud.h
//  KMMerchant
//
//  Created by 123 on 2016/10/25.
//  Copyright © 2016年 KMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Hud)

// 显示菊花和文字(可选),需要手动消失,用于网络请求开始时
- (void)showInfo:(NSString *)info;

// 只显示提示文字信息,自动消失
- (void)showOnlyPromptInfo:(NSString *)info;

// 显示自定义的提示信息(图片 + 文字),自动消失
- (void)showCustomInfo:(NSString *)info withImage:(UIImage *)image;

// 显示提示消息时并处理相关事务,(duration)秒后自动消失
- (void)showInfo:(NSString *)info duration:(CGFloat)duration withExecutingBlock:(void (^)(void))block completionBlock:(void (^)(void))completionBlock;

// 隐藏
- (void)dismiss;

- (UIView *)getHudSuperView;
@end
